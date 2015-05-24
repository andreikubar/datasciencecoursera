
act_labels<-read.table(file="activity_labels.txt")
head(act_labels)

act_test<-read.table(file="test/y_test.txt")
subj_test<-read.table(file="test/subject_test.txt")
names(subj_test)<-"subject"
records_test<-read.table(file="test/X_test.txt", sep=" ")

act_train<-read.table(file="train/y_train.txt")
subj_train<-read.table(file="train/subject_train.txt")
names(subj_train)<-"subject"
records_train<-read.table(file="train/X_train.txt", sep="")

features<-read.table("features.txt")

col_names<-as.character(features[,2])
names(records_train)<-col_names
names(records_test)<-col_names

grep_filter<-"(Mean|mean|Std|std)"
fltr_names_test<-grep(grep_filter,names(records_test),perl=T)
fltr_names_train<-grep(grep_filter,names(records_train),perl=T)

records_test<-records_test[,fltr_names_test]
records_train<-records_train[,fltr_names_train]

act_desc_test <- merge(act_test,act_labels,by=1)[,2]
act_desc_train <- merge(act_train,act_labels,by=1)[,2]

records_test_cmd<-cbind("activity"=act_desc_test,subj_test,records_test)
records_train_cmd<-cbind("activity"=act_desc_train,subj_train,records_train)

all_records<-rbind(records_test_cmd,records_train_cmd)
library(dplyr)
summarise (group_by(all_records,activity,subject) , mean=mean("fBodyAccMag-mean()")) 

head( all_records[,1:2])
gr <- ( group_by(all_records,activity,subject) )

sum_data <- all_records %>% group_by(subject,activity) %>% summarise_each(funs(mean))
write.table(sum_data,file="sum_data.txt",row.names=FALSE)

