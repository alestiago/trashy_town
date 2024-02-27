// this file is used to move and order the images in the hopping folder

const fs = require("fs");
const path = require("path");
const { copyFile } = require("fs").promises;

// Function to copy PNG files from subdirectories to parent directory
const copyPNGsToParent = async () => {
  const parentDir = "./"; // Parent directory
  const subDirs = fs
    .readdirSync(parentDir, { withFileTypes: true })
    .filter((dirent) => dirent.isDirectory())
    .map((dirent) => dirent.name)
    .sort(); // Get subdirectories and sort alphabetically

  let fileCounter = 1; // Initialize file counter

  for (const subDir of subDirs) {
    const subDirPath = path.join(parentDir, subDir);
    const files = fs.readdirSync(subDirPath); // Get files in subdirectory

    for (const file of files) {
      if (path.extname(file).toLowerCase() === ".png") {
        // Check if file is a PNG
        const oldFilePath = path.join(subDirPath, file);
        const newFileName = `${fileCounter++}.png`; // Create new filename with incremented number and PNG extension
        const newFilePath = path.join(parentDir, newFileName);

        await copyFile(oldFilePath, newFilePath); // Copy PNG file to parent directory with new filename
      }
    }
  }

  console.log("PNG files copied successfully.");
};

// Call the function
copyPNGsToParent();
