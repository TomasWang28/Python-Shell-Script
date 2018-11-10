/*
SQLyog Ultimate v12.08 (32 bit)
MySQL - 5.5.45 : Database - Lemon_GO
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`Lemon_GO` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `Lemon_GO`;

/*Table structure for table `Audit` */

DROP TABLE IF EXISTS `Audit`;

CREATE TABLE `Audit` (
  `audit_id` int(11) NOT NULL AUTO_INCREMENT,
  `audit_type` char(10) DEFAULT NULL,
  `audit_op` varchar(120) DEFAULT NULL,
  `audit_time` datetime DEFAULT NULL,
  `audit_user` char(20) DEFAULT NULL,
  PRIMARY KEY (`audit_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `Audit` */

insert  into `Audit`(`audit_id`,`audit_type`,`audit_op`,`audit_time`,`audit_user`) values (1,'cron','add','2016-08-23 17:50:37','admin');

/*Table structure for table `backup` */

DROP TABLE IF EXISTS `backup`;

CREATE TABLE `backup` (
  `backup_id` int(10) NOT NULL AUTO_INCREMENT,
  `backup_jobname` varchar(50) NOT NULL,
  `backup_ipaddr` varchar(15) NOT NULL,
  `ssh_port` int(5) NOT NULL,
  `backup_source` varchar(80) NOT NULL,
  `backup_destination` char(80) NOT NULL,
  `backup_shedule` varchar(20) DEFAULT NULL,
  `backup_owner` varchar(16) DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `last_runtime` datetime DEFAULT NULL,
  `backup_state` char(10) DEFAULT NULL,
  `backup_server` varchar(20) NOT NULL,
  PRIMARY KEY (`backup_id`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8;

/*Data for the table `backup` */

insert  into `backup`(`backup_id`,`backup_jobname`,`backup_ipaddr`,`ssh_port`,`backup_source`,`backup_destination`,`backup_shedule`,`backup_owner`,`created_time`,`last_runtime`,`backup_state`,`backup_server`) values (3,'jboss','10.1.2.3',22,'/opt','/opt/backup','00 02 * * *','haha','2015-12-21 15:29:20','2016-04-22 16:15:00','sucess','backup_server_01'),(79,'nagios','1.1.1.2',10022,'/opt/jboss/','/opt/backup/jboss/','00 01 * * *','我被青','2016-04-06 17:11:46','2016-04-25 10:58:41','sucess','backup_server_01'),(84,'test','10.2.2.1',22,'/etc/named/','/opt/Backup/','00 01 12 * *','wawa','2016-07-06 13:45:51',NULL,NULL,'backup_server_02'),(95,'om-center','10.48.192.160',22,'/etc/ssh/','/opt/Backup/etc/ssh/','00 01 * * 2','mgcheng','2016-07-18 09:26:30','2016-08-23 01:00:02','Failed','om-center'),(98,'test-client.mgtest.com','10.48.192.205',22,'/tmp','/opt/Backup/test-client.mgtest.com_tmp','00 01 * * *','mgcheng','2016-07-19 17:39:02','2016-08-23 01:00:02','Failed','om-center');

/*Table structure for table `backup_server` */

DROP TABLE IF EXISTS `backup_server`;

CREATE TABLE `backup_server` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `server_name` varchar(30) DEFAULT NULL,
  `ipaddress` varchar(15) DEFAULT NULL,
  `backup_folder` varchar(20) DEFAULT NULL,
  `backup_user` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

/*Data for the table `backup_server` */

insert  into `backup_server`(`id`,`server_name`,`ipaddress`,`backup_folder`,`backup_user`) values (1,'backup_server_01','10.2.2.2','/opt/Backup/','backup'),(2,'backup_server_02','192.1.2.1','/opt/Backup/','backup'),(3,'backup_server_03','10.2.1.2','/opt/Backup/','backup'),(35,'test','1.1.1.1','/opt/Backup','backup'),(34,'om-center','10.48.192.162','/opt/Backup','backup');

/*Table structure for table `cron` */

DROP TABLE IF EXISTS `cron`;

CREATE TABLE `cron` (
  `cron_id` int(11) NOT NULL AUTO_INCREMENT,
  `cron_name` varchar(30) DEFAULT NULL,
  `cron_command` varchar(50) DEFAULT NULL,
  `cron_schedule` char(20) DEFAULT NULL,
  `cron_owner` char(10) DEFAULT NULL,
  `cron_server` char(20) DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `cron_user` char(10) DEFAULT NULL,
  PRIMARY KEY (`cron_id`),
  UNIQUE KEY `cron_name` (`cron_name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

/*Data for the table `cron` */

insert  into `cron`(`cron_id`,`cron_name`,`cron_command`,`cron_schedule`,`cron_owner`,`cron_server`,`created_time`,`cron_user`) values (8,'test','ls /tmp','30 02 * * *','harvey','test-server','2016-08-16 09:34:21','root'),(10,'gog','ls -l /opt','00 12 * * *','aa','aaa','2016-08-16 14:00:45','root'),(15,'where','ls /opt','00 01 * * *','张三','wherfe','2016-08-16 17:16:32','jboss'),(16,'this is a test','ls /tmp','00 01 * * *','mgcheng','om-center','2016-08-16 17:26:05','root'),(17,'afasfasf','ls /tmp','00 01 * * *','mgcheng','om-center','2016-08-16 17:26:05','test');

/*Table structure for table `department` */

DROP TABLE IF EXISTS `department`;

CREATE TABLE `department` (
  `department_id` int(11) NOT NULL AUTO_INCREMENT,
  `department_name` char(20) DEFAULT NULL,
  PRIMARY KEY (`department_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `department` */

insert  into `department`(`department_id`,`department_name`) values (1,'IBS'),(2,'ICS'),(3,'TOP'),(4,'HR'),(5,'IT');

/*Table structure for table `nagios_host` */

DROP TABLE IF EXISTS `nagios_host`;

CREATE TABLE `nagios_host` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `nagios_host` */

/*Table structure for table `nagios_service` */

DROP TABLE IF EXISTS `nagios_service`;

CREATE TABLE `nagios_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `nagios_service` */

/*Table structure for table `roles` */

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(64) DEFAULT NULL,
  `role_comment` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `roles` */

insert  into `roles`(`id`,`role_name`,`role_comment`) values (1,'Administrator','access all feature'),(2,'User',NULL),(3,'Guest',NULL),(4,'Develop','Developement team tools');

/*Table structure for table `server` */

DROP TABLE IF EXISTS `server`;

CREATE TABLE `server` (
  `server_id` int(10) NOT NULL AUTO_INCREMENT,
  `server_hostname` varchar(50) NOT NULL,
  `server_ipaddr` varchar(15) DEFAULT '-.-.-.-',
  `server_os` varchar(20) DEFAULT NULL,
  `server_cpu` varchar(80) DEFAULT NULL,
  `server_memory` char(20) DEFAULT NULL,
  `server_model` varchar(40) DEFAULT NULL,
  `server_application` varchar(50) DEFAULT NULL,
  `server_owner` varchar(16) DEFAULT NULL,
  `server_location` varchar(16) DEFAULT NULL,
  `server_sn` varchar(16) DEFAULT NULL,
  `server_warranty` date DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `updated_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `server_remarks` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`server_id`),
  UNIQUE KEY `server_hostname` (`server_hostname`),
  UNIQUE KEY `server_ipaddr` (`server_ipaddr`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;

/*Data for the table `server` */

insert  into `server`(`server_id`,`server_hostname`,`server_ipaddr`,`server_os`,`server_cpu`,`server_memory`,`server_model`,`server_application`,`server_owner`,`server_location`,`server_sn`,`server_warranty`,`created_time`,`updated_time`,`server_remarks`) values (110,'test-client','10.48.192.205','CentOS-6.7-x86_64','1 * Intel(R) Xeon(R) CPU E5-2609 0 @ 2.40GHz','1877','VMware',NULL,NULL,NULL,NULL,'2016-07-14','2016-07-22 09:55:00','2016-07-22 16:25:41',NULL),(111,'om-center','10.48.192.162','CentOS-6.8-x86_64','1 * Intel(R) Xeon(R) CPU E5-2609 0 @ 2.40GHz','980','VMware','OM','','','','2016-07-28','2016-07-22 09:55:00','2016-07-22 17:31:58',''),(132,'TEST2','10.1.1.1','MAC OS','2','2000','','','','上海office','','2016-08-18','2016-07-22 14:49:59','2016-07-22 17:32:23','张三的测试机'),(133,'TEST3','10.1.1.11','MAC OS','2','2000','','','张三','上海office','','2016-07-31','2016-07-22 14:53:51','2016-07-22 16:39:13','张三的测试机');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(64) DEFAULT NULL,
  `user_email` varchar(64) DEFAULT NULL,
  `password_hash` varchar(128) DEFAULT NULL,
  `created_time` datetime DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `user_group` char(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_users_email` (`user_email`),
  UNIQUE KEY `ix_users_user_name` (`user_name`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

/*Data for the table `users` */

insert  into `users`(`id`,`user_name`,`user_email`,`password_hash`,`created_time`,`role_id`,`user_group`) values (1,'admin','admin@lemon.com','pbkdf2:sha1:1000$ISzcv13G$e60726cc7237be1cd9000f540a3d4681712cebb0','2016-06-15 17:50:44',1,NULL),(12,'gaga','gaga@lemon.com','pbkdf2:sha1:1000$TjYDpWcE$564293f5ddcc20848d78a0b870ae1972822bb345','2016-07-01 16:42:14',4,NULL),(13,'lala','lala@lemon.com','pbkdf2:sha1:1000$TvuGbBsq$95cc6a0f4177ae258a571c6ff02d9347c710b68a','2016-07-01 17:58:10',2,NULL),(14,'mgcheng','minggong.cheng@99wuxian.com','pbkdf2:sha1:1000$5PEFp9mS$79ec740bd123b97b19678e614b798e2f9176fe4b','2016-07-26 11:36:05',1,NULL);

/*Table structure for table `work_orders` */

DROP TABLE IF EXISTS `work_orders`;

CREATE TABLE `work_orders` (
  `wo_id` int(11) NOT NULL AUTO_INCREMENT,
  `wo_sn` char(14) DEFAULT NULL,
  `wo_content` varchar(500) DEFAULT NULL,
  `wo_type` char(20) DEFAULT NULL,
  `wo_department` char(20) DEFAULT NULL,
  `submitter` char(20) DEFAULT NULL,
  `submit_time` datetime DEFAULT NULL,
  `wo_accepter` char(20) DEFAULT NULL,
  `wo_group` char(20) DEFAULT NULL,
  `wo_state` char(20) DEFAULT NULL,
  `wo_priority` char(10) DEFAULT NULL,
  `accept_time` datetime DEFAULT NULL,
  `done_time` datetime DEFAULT NULL,
  `process_time` float DEFAULT NULL,
  `response_time` float DEFAULT NULL,
  PRIMARY KEY (`wo_id`),
  UNIQUE KEY `wo_sn` (`wo_sn`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `work_orders` */

insert  into `work_orders`(`wo_id`,`wo_sn`,`wo_content`,`wo_type`,`wo_department`,`submitter`,`submit_time`,`wo_accepter`,`wo_group`,`wo_state`,`wo_priority`,`accept_time`,`done_time`,`process_time`,`response_time`) values (3,'201607251407','硬件故障','资源申请','IBS','admin','2016-07-25 14:47:07','mgcheng','IT','正在处理','中等','2016-07-29 11:02:11',NULL,NULL,NULL),(4,'201607251419','qqqqaf我要飞得列工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工工','技术支持','IBS','admin','2016-07-25 14:51:19','admin','SCM','正在处理','中等','2016-07-28 15:51:17',NULL,NULL,NULL),(5,'201607251402','工工aaaaaaaaaaaaaaaaaaaa','资源申请','IBS','admin','2016-07-25 14:59:02','admin','IT','正在处理','一般','2016-07-29 15:51:27',NULL,NULL,NULL),(6,'20160725152328','AFDFASFSFASFA','技术支持','IBS','admin','2016-07-25 15:23:28','admin','SYS','已完成','中等','2016-07-29 15:51:32','2016-07-29 16:18:35',27.05,28.0667),(8,'5YLvI072515271','加个VPN','资源申请','IBS','admin','2016-07-25 15:27:17','mgcheng','IT','已完成','中等','2016-07-29 11:00:49','2016-07-29 16:16:40',315.85,1173.53),(9,'y2Yw7072911551','吃饭睡觉打豆豆','技术支持','IBS','mgcheng','2016-07-29 11:55:00','mgcheng','IT','正在处理',NULL,'2016-07-29 11:57:24',NULL,NULL,NULL),(10,'KL9dT072916202','工工工工工工工工工工','技术支持','IBS','mgcheng','2016-07-29 16:20:26',NULL,'IT','待处理',NULL,NULL,NULL,NULL,NULL),(12,'XPoeB080109352','faaaaaaaaaaaaaaaaaaaaaaa','技术支持','TOP','admin','2016-08-01 09:35:20',NULL,'IT','待处理',NULL,NULL,NULL,NULL,NULL),(13,'uAtE6081015271','afasfasfasfasf','资源申请','TOP','admin','2016-08-10 15:27:14','admin','IT','正在处理',NULL,'2016-08-12 11:46:37',NULL,NULL,NULL);

/* Procedure structure for procedure `hi` */

/*!50003 DROP PROCEDURE IF EXISTS  `hi` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`mgcheng`@`%` PROCEDURE `hi`()
select 'hello' */$$
DELIMITER ;

/* Procedure structure for procedure `sp_wo_statistic` */

/*!50003 DROP PROCEDURE IF EXISTS  `sp_wo_statistic` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`mgcheng`@`%` PROCEDURE `sp_wo_statistic`(IN p_wo_group CHAR(20))
BEGIN
SELECT * FROM work_orders WHERE wo_group = p_wo_group;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
