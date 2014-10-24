x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep = "",
                    header = FALSE);
y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep = "",
                    header = FALSE);
subj_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep = "",
                       header = FALSE);
train <- cbind(x_train, y_train, subj_train);


x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep = "",
                   header = FALSE);
y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep = "",
                   header = FALSE);
subj_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep = "",
                      header = FALSE);
test <- cbind(x_test, y_test, subj_test);

all <- rbind(train, test);

activity_lab <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep = "",
                         header = FALSE);

features <- read.csv("./UCI HAR Dataset/features.txt", sep = "",
                     header = FALSE);

mu_sds <- grep(".*[mM]ean.*|.*[sS]td.*", features[, 2]);
mu_features <- as.character(features[mu_sds, 2]);

all <- all[, c(mu_sds, 562, 563)]; # 562: y; 563: subject
names(all) <- c(mu_features, "Activity", "Subject");

cur <- 1;
for (lab in activity_lab) {
    all$Activity <- gsub(cur, lab, all$Activity);
    cur <- cur + 1;
}

all$Activity <- as.factor(all$Activity);
all$Subject <- as.factor(all$Subject);

tidy_data <- aggregate(all, list(activity = all$Activity, subject = all$Subject),
                       mean);
tidy_data[, 89] <- NULL;
tidy_data[, 90] <- NULL;
write.table(tidy_data, "tidy_data.txt", sep = "\t", row.name = FALSE);
