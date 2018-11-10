#!/bin/bash
ftp_config(){
sed -i 's/^$/d;/^#/d' /etc/vsftpd/vsftpd.conf
sed -i 's/\(local_enable=\).\{1,3\}/\1NO/g' /etc/vsftpd/vsftpd.conf
sed -i 's/\(anonymous_enable=\).\{1,3\}/\1YES/g' /etc/vsftpd/vsftpd.conf
sed -i 's/\(anon_upload_enable=\).\{1,3\}/\1YES/g' /etc/vsftpd/vsftpd.conf
sed -i 's/\(anon_mkdir_write_enable=\).\{1,3\}/\1YES/g' /etc/vsftpd/vsftpd.conf
sed -i 's/\(anon_max_rate=\).*/\1524288/g' /etc/vsftpd/vsftpd.conf



def_anonconf=(
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
anon_max_rate=524288
)
for each in ${def_anonconf[@]}
    grep "$each" /etc/vsftpd/vsftpd.conf 
    if [ $? != 0 ];then
    echo $each &>/dev/null >> /etc/vsftpd/vsftpd.conf     
}


main(){
#    def_install_vsftpd(){
    rpm -q vsftpd
    if [ $? != 0 ];then
    yum install vsftpd -y
    fi
#}
#    return def_install_vsftpd
    ftp_config
    service vsftpd restart
}

main