const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "shoesly-firebase1-app.appspot.com",
});
const db = admin.firestore();
const storage = admin.storage(); // Initialize Firebase Storage

// Cloud Function to handle new shoe entry and check if there is any new color
// if so it will enter it in the colors collection
exports.checkAndAddColors = functions.firestore
    .document("shoes/{shoeId}")
    .onCreate(async (snap, context) => {
      const newShoe = snap.data();
      const colorsAvailable = newShoe.colorsAvailable;

      if (!colorsAvailable) {
        console.log("No colors available in the new shoe document.");
        return;
      }

      // Get the colors document
      const colorsDocRef = db.collection("colors").doc("colorsAvailable");
      const colorsDoc = await colorsDocRef.get();

      if (!colorsDoc.exists) {
        console.log("Colors document does not exist. Creating a new one.");
        await colorsDocRef.set(colorsAvailable);
        return;
      }

      const existingColors = colorsDoc.data();
      let updated = false;

      // Check and add missing colors
      for (const [colorCode, colorName] of Object.entries(colorsAvailable)) {
        if (!existingColors[colorCode]) {
          existingColors[colorCode] = colorName;
          updated = true;
        }
      }

      if (updated) {
        await colorsDocRef.set(existingColors, {merge: true});
        console.log("Updated colors document with new colors.");
      } else {
        console.log("No new colors to add.");
      }
    });

// Cloud function for counting the number of total shoes of a particular brand
exports.updateBrandsCollection = functions.firestore
    .document("shoes/{shoeId}")
    .onCreate(async (snap, context) => {
      const newShoe = snap.data();
      const brandName = newShoe.brandName;
      const brandNameLowerCase = brandName
          .toLowerCase(); // Ensure consistent case

      // Check if the brand already exists in the brands collection
      const brandDocRef = db.collection("brands").doc(brandNameLowerCase);
      const brandDoc = await brandDocRef.get();

      // Update or create brand entry in the brands collection
      if (brandDoc.exists) {
        // Brand already exists, update totalShoes count
        const totalShoes = (brandDoc.data().totalShoes || 0) + 1;
        await brandDocRef.update({totalShoes});
      } else {
        // Brand doesn't exist, create new entry
        const newBrandData = {
          brandName,
          totalShoes: 1, // Initial count
        };
        await brandDocRef.set(newBrandData);
      }

      let logoUrl = (await brandDocRef.get()).data().logoUrl;

      // If logoUrl is empty or doesn't exist, fetch it from Firebase Storage
      if (!logoUrl) {
        const logoFileName = `${brandNameLowerCase}_logo.svg`;
        const logoFileRef = storage.bucket()
            .file(`brand_logos/${logoFileName}`);

        try {
          // Get the signed URL for the logo file
          const [signedUrl] = await logoFileRef
              .getSignedUrl({action: "read", expires: "01-01-2100"});
          logoUrl = signedUrl;
          const newBrandData = {
            logoUrl, // Initial count
          };
          await brandDocRef.update(newBrandData);
        } catch (error) {
          console.error("Error fetching logo URL:", error);
        }
      }

      console.log(`Updated brands collection for brand: ${brandName}`);
    });

exports.updateShoeStats = functions.firestore
    .document("shoes/{shoeId}/reviews/{reviewId}")
    .onCreate((snap, context) => {
      const shoeId = context.params.shoeId;

      const reviewData = snap.data();
      const rating = reviewData.rating;

      // Get reference to the shoe document
      const shoeRef = admin.firestore().collection("shoes").doc(shoeId);

      // Update totalReviews and avgRating fields in the shoe document
      return admin.firestore().runTransaction((transaction) => {
        return transaction.get(shoeRef).then((shoeDoc) => {
          if (!shoeDoc.exists) {
            throw new Error("Shoe document does not exist");
          }

          const data = shoeDoc.data();
          const currentTotalReviews = data.totalReviews || 0;
          const currentAvgRating = data.avgRating || 0;

          const newTotalReviews = currentTotalReviews + 1;
          const newAvgRating =
          ((currentAvgRating * currentTotalReviews) + rating) / newTotalReviews;

          // Update the shoe document with new values
          return transaction.update(shoeRef, {
            totalReviews: newTotalReviews,
            avgRating: newAvgRating,
          });
        });
      }).catch((error) => {
        console.error("Error updating shoe document:", error);
        return Promise.reject(error);
      });
    });
