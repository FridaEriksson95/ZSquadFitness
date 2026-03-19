/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onCall, HttpsError} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {defineSecret} from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import {Resend} from "resend";

admin.initializeApp();

setGlobalOptions({maxInstances: 10, region: "europe-west1"});

export const deleteUserAccountData = onCall(
  {region: "europe-west1"},
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated",
        "Login required");
    }

    const uid = request.auth.uid;
    const db = admin.firestore();


    const bookingRef = db.collection("users").doc(uid)
      .collection("bookings");
    const bookingsSnap = await bookingRef.get();

    const classCounts = new Map<string, number>();
    for (const doc of bookingsSnap.docs) {
      const classId = doc.data().classId as string | undefined;
      if (!classId) continue;
      classCounts.set(classId, (classCounts.get(classId) ?? 0) + 1);
    }

    for (const [classId, count] of classCounts.entries()) {
      const classRef = db.collection("classes").doc(classId);
      await db.runTransaction(async (tx) => {
        const snap = await tx.get(classRef);
        if (!snap.exists) return;
        const booked = Number(snap.data()?.spotsBooked ?? 0);
        tx.update(classRef, {spotsBooked:
          Math.max(0, booked - count)});
      });
    }

    let batch = db.batch();
    let opCount = 0;
    for (const doc of bookingsSnap.docs) {
      batch.delete(doc.ref);
      opCount++;
      if (opCount === 450) {
        await batch.commit();
        batch = db.batch();
        opCount = 0;
      }
    }

    if (opCount > 0) await batch.commit();

    await db.collection("users").doc(uid).delete();

    await admin.auth().deleteUser(uid);

    return {ok: true};
  },
);

const RESEND_API_KEY = defineSecret("RESEND_API_KEY");

const ConfirmationStatus = {
  pending: "pending",
  skipped: "skipped",
  sent: "sent",
  failed: "failed",
} as const;

export const sendBookingConfirmation = onDocumentCreated(
  {
    document: "users/{userId}/bookings/{bookingId}",
    secrets: [RESEND_API_KEY],
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.warn("No snapshot data in event.");
      return;
    }

    const booking = snapshot.data();
    const userId = event.params.userId;
    const bookingId = event.params.bookingId;

    logger.info("Booking created", {userId, bookingId, booking});

    if (!booking?.sendConfirmation) {
      logger.info("Confirmation skipped: sendConfirmation is false", {
        userId,
        bookingId,
      });
      return;
    }

    if (booking.confirmationStatus !== ConfirmationStatus.pending) {
      logger.info("Confirmation skipped: status is not pending", {
        userId,
        bookingId,
        status: booking.confirmationStatus,
      });
      return;
    }

    const userRef = admin.firestore().collection("users").doc(userId);
    const userSnap = await userRef.get();
    const userData = userSnap.data();

    const clientEmail = userData?.Email;
    const clientName = userData?.Name ?? "Z Squader";

    if (!clientEmail) {
      logger.error("Missing email for booking confirmation", {
        userId,
        bookingId,
      });

      await snapshot.ref.update({
        confirmationStatus: ConfirmationStatus.failed,
        confirmationError: "Missing client email",
      });
      return;
    }

    const resend = new Resend(RESEND_API_KEY.value());

    try {
      await resend.emails.send({
        from: "ZSquad Fitness <noreply@zsquadfitness.se>",
        to: clientEmail,
        subject: `Bokningsbekräftelse: ${booking.title ?? "Pass"}`,
        html: `
  <div style="margin:0;padding:0;
  background-color:#0b0f14;
  font-family:Arial,Helvetica,sans-serif;color:#ffffff;">
    <div style="max-width:600px;margin:0 auto;padding:32px 20px;">
      <div style="text-align:center;margin-bottom:24px;">
        <h1 style="margin:0;font-size:28px;
        letter-spacing:0.5px;color:#9dff00;">
          ZSquad Fitness
        </h1>
        <p style="margin:8px 0 0 0;font-size:15px;color:#cfd6dd;">
          Din bokning är bekräftad
        </p>
      </div>
      <div style="background-color:#121821;
      border:1px solid rgba(157,255,0,0.25);
      border-radius:18px;padding:24px;
      box-shadow:0 8px 24px rgba(0,0,0,0.25);">
        <p style="margin:0 0 18px 0;font-size:16px;color:#ffffff;">
          Hej ${clientName}!
        </p>
        <p style="margin:0 0 20px 0;
        font-size:15px;line-height:1.6;color:#cfd6dd;">
          Du är nu bokad på följande pass:
        </p>
        <div style="background-color:#0f141b;
        border-radius:14px;padding:18px 16px;">
          <div style="margin-bottom:12px;">
            <div style="font-size:12px;color:#7f8b96;
            text-transform:uppercase;letter-spacing:0.8px;">
              Pass
            </div>
            <div style="font-size:18px;font-weight:bold;color:#ffffff;">
              ${booking.title ?? "-"}
            </div>
          </div>
          <div style="margin-bottom:12px;">
            <div style="font-size:12px;color:#7f8b96;
            text-transform:uppercase;letter-spacing:0.8px;">
              Datum
            </div>
            <div style="font-size:16px;color:#ffffff;">
              ${booking.date ?? "-"}
            </div>
          </div>
          <div style="margin-bottom:12px;">
            <div style="font-size:12px;color:#7f8b96;
            text-transform:uppercase;letter-spacing:0.8px;">
              Tid
            </div>
            <div style="font-size:16px;color:#ffffff;">
              ${booking.time ?? "-"}
            </div>
          </div>
          <div style="margin-bottom:12px;">
            <div style="font-size:12px;color:#7f8b96;
            text-transform:uppercase;letter-spacing:0.8px;">
              Plats
            </div>
            <div style="font-size:16px;color:#ffffff;">
              ${booking.locationName ?? "-"}
            </div>
          </div>
          <div style="margin-bottom:12px;">
            <div style="font-size:12px;color:#7f8b96;
            text-transform:uppercase;letter-spacing:0.8px;">
              Adress
            </div>
            <div style="font-size:16px;color:#ffffff;">
              ${booking.locationAddress ?? "-"}
            </div>
          </div>
          <div>
            <div style="font-size:12px;color:#7f8b96;
            text-transform:uppercase;letter-spacing:0.8px;">
              Sal
            </div>
            <div style="font-size:16px;color:#ffffff;">
              ${booking.room ?? "-"}
            </div>
          </div>
        </div>
        <div style="margin-top:22px;padding:14px 16px;
        border-radius:12px;
        background-color:rgba(53,222,203,0.10);
        border:1px solid rgba(53,222,203,0.25);">
          <p style="margin:0;font-size:14px;
          line-height:1.6;color:#d8fffa;">
            Tack för din bokning. Vi ses på passet!
          </p>
        </div>
      </div>
      <div style="text-align:center;margin-top:24px;">
        <p style="margin:0;font-size:13px;color:#7f8b96;">
          Detta är ett automatiskt skickat mejl från ZSquad Fitness.
        </p>
      </div>
    </div>
  </div>
`,
      });

      await snapshot.ref.update({
        confirmationStatus: ConfirmationStatus.sent,
        confirmationSentAt: admin.firestore.FieldValue.serverTimestamp(),
        confirmationError: admin.firestore.FieldValue.delete(),
      });

      logger.info("Booking confirmation sent", {
        userId,
        bookingId,
        clientEmail,
      });
    } catch (error) {
      logger.error("Failed to send booking confirmation", {
        userId,
        bookingId,
        error,
      });

      await snapshot.ref.update({
        confirmationStatus: ConfirmationStatus.failed,
        confirmatiomError: error instanceof Error ?
          error.message : "Unknown error",
      });
    }
  },
);
