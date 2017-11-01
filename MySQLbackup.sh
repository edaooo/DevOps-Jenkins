#!/bin/bash
printf "\n\n---------------------------------------!! Backing up DB's ($(date)) !!--------------------------------------- \n\n"
backup_date="$(date +'%m_%d_%Y(%H.%M.%S)')"
db_backup_dir="/opt/active/db_backs"
db_backup_name="activex_db_${backup_date}.sql"
db_backup_full_path_and_name="${db_backup_dir}/${db_backup_name}"


create_db_backup() {
  db_host="prod-axtrainer-mysql-01w.at.active.tan"
  db_username="verys"
  db_password="verys!234"

  printf "\n---------------------------------------!! Getting the latest backup of all the activex databases !!--------------------------------------- \n\n"
  return $(mysqldump -h $db_host -u $db_username -p$db_password --all-databases > $db_backup_full_path_and_name)
}

tar_the_db_backup() {
  $(cd $db_backup_dir && tar -cvzf "${db_backup_name}.tar.gz" $db_backup_name)
}

remove_large_sql_file() {
  $(rm $db_backup_full_path_and_name)
}

create_db_backup
printf "\n---------------------------------------!! Tar'ing SQL File (Save Space) !!---------------------------------------\n\n"
tar_the_db_backup
printf "\n---------------------------------------!! Remove SQL file (duplicate) !!---------------------------------------\n\n"
remove_large_sql_file
printf "\n---------------------------------------!! Finished creating backups !!---------------------------------------\n\n"
exit $?
