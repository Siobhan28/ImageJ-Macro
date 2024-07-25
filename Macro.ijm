//from https://github.com/Siobhan28/ImageJ-Macro
// Define the input and output directories
inputDir = "/your/path/to/your/Image/folder";
outputDir = "/your/path/to/your/Image/output/folder";
classifierPath = "/your/path/to/your/classifier";

// Get the list of image files in the directory
list = getFileList(inputDir);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".jpg") || endsWith(list[i], ".JPG") || endsWith(list[i], ".png") || endsWith(list[i], ".PNG")) {
        // Open the image
        open(inputDir + "/" + list[i]);
        
        // Resize the image if needed
        run("Scale...", "x=- y=- width=1000 height=750 interpolation=Bilinear average create");
        
        // Get the title of the resized image
        resizedTitle = getTitle();
        print("Resized image title: " + resizedTitle);
        
        // Ensure the original image is closed
        originalTitle = list[i];
        close(originalTitle);
        
        // Run Trainable Weka Segmentation
        run("Trainable Weka Segmentation");
        wait(5000); // Wait for 5 seconds to ensure the segmentation window is open

        // Check if the segmentation window is open
        if (!isOpen("Trainable Weka Segmentation v3.3.4")) {
            print("Error: Trainable Weka Segmentation window did not open.");
            close();
            continue;
        }

        // Load the classifier and get the result
        selectWindow("Trainable Weka Segmentation v3.3.4");
        call("trainableSegmentation.Weka_Segmentation.loadClassifier", classifierPath);
        call("trainableSegmentation.Weka_Segmentation.getResult");
        wait(5000); // Wait for 5 seconds to ensure classification is complete
        
        // Select the classified image and save it
        classifiedTitle = "Classified image";
        if (isOpen(classifiedTitle)) {
            selectWindow(classifiedTitle);
            savePath = outputDir + "/" + replace(list[i], ".", "_classified.") + ".png";
            print("Saving classified image to: " + savePath);
            saveAs("PNG", savePath);
        } else {
            print("Error: Classified image window did not open.");
        }
        
        // Close the classified image and the resized image
        if (isOpen(classifiedTitle)) {
            selectWindow(classifiedTitle);
            close();
        }
        
        if (isOpen(resizedTitle)) {
            selectWindow(resizedTitle);
            close();
        }
        
        // Close any additional open windows to clean up
        run("Close All");
        wait(1000); // Wait 1 second to ensure all windows are closed
    }
}
