-- MySQL dump 10.14  Distrib 5.5.50-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: organisasi
-- ------------------------------------------------------
-- Server version	5.5.50-MariaDB
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` VALUES (1,'admin','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8','Administrator',1,'aktif','oKOPMjmBfG','2016-10-16 15:19:01');

--
-- Dumping data for table `admin_grup`
--

INSERT INTO `admin_grup` VALUES (1,'Super Admin');

--
-- Dumping data for table `aktifitas`
--


--
-- Dumping data for table `aktifitas_foto`
--


--
-- Dumping data for table `aktifitas_skor`
--


--
-- Dumping data for table `dpd`
--

INSERT INTO `dpd` VALUES (1,'Jakarta Timur');

--
-- Dumping data for table `halaman`
--

INSERT INTO `halaman` VALUES (1,'/home/index','Dasbor');
INSERT INTO `halaman` VALUES (2,'/admin/index','Admin');
INSERT INTO `halaman` VALUES (3,'/admin/tambah_admin','Tambah Admin');
INSERT INTO `halaman` VALUES (4,'/admin/edit_admin','Edit Admin');
INSERT INTO `halaman` VALUES (5,'/admin/hapus_admin','Hapus Admin');
INSERT INTO `halaman` VALUES (6,'/admin/admin_grup','Admin Grup');
INSERT INTO `halaman` VALUES (7,'/admin/tambah_admin_grup','Tambah Admin Grup');
INSERT INTO `halaman` VALUES (8,'/admin/edit_admin_grup','Edit Admin Grup');
INSERT INTO `halaman` VALUES (9,'/admin/hapus_admin_grup','Hapus Admin Grup');
INSERT INTO `halaman` VALUES (10,'/dpd/index','DPD');
INSERT INTO `halaman` VALUES (11,'/dpd/tambah_dpd','Tambah DPD');
INSERT INTO `halaman` VALUES (12,'/dpd/edit_dpd','Edit DPD');
INSERT INTO `halaman` VALUES (13,'/dpd/hapus_dpd','Hapus DPD');
INSERT INTO `halaman` VALUES (14,'/dpd/kecamatan','Kecamatan');
INSERT INTO `halaman` VALUES (15,'/dpd/tambah_kecamatan','Tambah Kecamatan');
INSERT INTO `halaman` VALUES (16,'/dpd/edit_kecamatan','Edit Kecamatan');
INSERT INTO `halaman` VALUES (17,'/dpd/hapus_kecamatan','Hapus Kecamatan');
INSERT INTO `halaman` VALUES (18,'/dpd/kelurahan','Kelurahan');
INSERT INTO `halaman` VALUES (19,'/dpd/tambah_kelurahan','Tambah Kelurahan');
INSERT INTO `halaman` VALUES (20,'/dpd/edit_kelurahan','Edit Kelurahan');
INSERT INTO `halaman` VALUES (21,'/dpd/hapus_kelurahan','Hapus Kelurahan');
INSERT INTO `halaman` VALUES (22,'/kategori/index','Kategori');
INSERT INTO `halaman` VALUES (23,'/kategori/tambah_kategori','Tambah Kategori');
INSERT INTO `halaman` VALUES (24,'/kategori/edit_kategori','Edit Kategori');
INSERT INTO `halaman` VALUES (25,'/kategori/hapus_kategori','Hapus Kategori');
INSERT INTO `halaman` VALUES (26,'/pengaturan/hak_akses','Hak Akses');
INSERT INTO `halaman` VALUES (27,'/kegiatan/index','Data Kegiatan');
INSERT INTO `halaman` VALUES (28,'/kegiatan/entri_kegiatan','Entri Data Kegiatan');
INSERT INTO `halaman` VALUES (29,'/kegiatan/detail_kegiatan','Detail Kegiatan');
INSERT INTO `halaman` VALUES (30,'/kegiatan/nilai_kegiatan','Nilai Kegiatan');
INSERT INTO `halaman` VALUES (31,'/kegiatan/grafik_kegiatan','Grafik Kegiatan');
INSERT INTO `halaman` VALUES (32,'/kegiatan/peta_kegiatan','Peta Kegiatan');
INSERT INTO `halaman` VALUES (33,'/dpd/upload_kecamatan','Upload Kecamatan dan Kelurahan');
INSERT INTO `halaman` VALUES (34,'/bidang/index','Bidang');
INSERT INTO `halaman` VALUES (35,'/bidang/tambah_bidang','Tambah Bidang');
INSERT INTO `halaman` VALUES (36,'/bidang/edit_bidang','Edit Bidang');
INSERT INTO `halaman` VALUES (37,'/bidang/hapus_bidang','Hapus Bidang');
INSERT INTO `halaman` VALUES (38,'/kegiatan/edit_kegiatan','Edit Kegiatan');

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` VALUES (1,NULL,'Pelayanan');
INSERT INTO `kategori` VALUES (2,NULL,'Kaderisasi');

--
-- Dumping data for table `kategori_detail`
--


--
-- Dumping data for table `kecamatan`
--

INSERT INTO `kecamatan` VALUES (1,1,'DS','Duren Sawit');
INSERT INTO `kecamatan` VALUES (2,1,'JN','Jatinegara');

--
-- Dumping data for table `kelurahan`
--


--
-- Dumping data for table `pemetaan`
--

INSERT INTO `pemetaan` VALUES (1,1);
INSERT INTO `pemetaan` VALUES (1,2);
INSERT INTO `pemetaan` VALUES (1,3);
INSERT INTO `pemetaan` VALUES (1,4);
INSERT INTO `pemetaan` VALUES (1,5);
INSERT INTO `pemetaan` VALUES (1,6);
INSERT INTO `pemetaan` VALUES (1,7);
INSERT INTO `pemetaan` VALUES (1,8);
INSERT INTO `pemetaan` VALUES (1,9);
INSERT INTO `pemetaan` VALUES (1,10);
INSERT INTO `pemetaan` VALUES (1,11);
INSERT INTO `pemetaan` VALUES (1,12);
INSERT INTO `pemetaan` VALUES (1,13);
INSERT INTO `pemetaan` VALUES (1,14);
INSERT INTO `pemetaan` VALUES (1,15);
INSERT INTO `pemetaan` VALUES (1,16);
INSERT INTO `pemetaan` VALUES (1,17);
INSERT INTO `pemetaan` VALUES (1,18);
INSERT INTO `pemetaan` VALUES (1,19);
INSERT INTO `pemetaan` VALUES (1,20);
INSERT INTO `pemetaan` VALUES (1,21);
INSERT INTO `pemetaan` VALUES (1,22);
INSERT INTO `pemetaan` VALUES (1,23);
INSERT INTO `pemetaan` VALUES (1,24);
INSERT INTO `pemetaan` VALUES (1,25);
INSERT INTO `pemetaan` VALUES (1,26);
INSERT INTO `pemetaan` VALUES (1,27);
INSERT INTO `pemetaan` VALUES (1,28);
INSERT INTO `pemetaan` VALUES (1,29);
INSERT INTO `pemetaan` VALUES (1,30);
INSERT INTO `pemetaan` VALUES (1,31);
INSERT INTO `pemetaan` VALUES (1,32);
INSERT INTO `pemetaan` VALUES (1,33);
INSERT INTO `pemetaan` VALUES (1,34);
INSERT INTO `pemetaan` VALUES (1,35);
INSERT INTO `pemetaan` VALUES (1,36);
INSERT INTO `pemetaan` VALUES (1,37);
INSERT INTO `pemetaan` VALUES (1,38);
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-17  8:07:49
