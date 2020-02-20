-- MySQL dump 10.14  Distrib 5.5.52-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: organisasi
-- ------------------------------------------------------
-- Server version	5.5.52-MariaDB
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `password` varchar(50) NOT NULL,
  `nama_lengkap` varchar(100) DEFAULT NULL,
  `admin_grup` tinyint(3) unsigned NOT NULL,
  `status` enum('aktif','tidak') DEFAULT 'aktif',
  `session_id` varchar(50) DEFAULT NULL,
  `akses_terakhir` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `admin_grup` (`admin_grup`),
  CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`admin_grup`) REFERENCES `admin_grup` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `admin_grup`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_grup` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aktifitas`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aktifitas` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `bidang` smallint(5) unsigned DEFAULT NULL,
  `kategori` smallint(5) unsigned NOT NULL,
  `kegiatan` varchar(100) DEFAULT NULL,
  `level` enum('dpd','dpc','dpra') DEFAULT 'dpd',
  `kelurahan` smallint(5) unsigned NOT NULL,
  `rw` varchar(10) DEFAULT NULL,
  `alamat` varchar(50) DEFAULT NULL,
  `koordinat` varchar(50) DEFAULT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `target` mediumint(8) unsigned NOT NULL,
  `realisasi` mediumint(8) unsigned NOT NULL,
  `ts_aktifitas` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `kategori` (`kategori`),
  KEY `kelurahan` (`kelurahan`),
  KEY `bidang` (`bidang`),
  CONSTRAINT `aktifitas_ibfk_1` FOREIGN KEY (`kategori`) REFERENCES `kategori` (`id`),
  CONSTRAINT `aktifitas_ibfk_2` FOREIGN KEY (`kelurahan`) REFERENCES `kelurahan` (`id`),
  CONSTRAINT `aktifitas_ibfk_3` FOREIGN KEY (`bidang`) REFERENCES `bidang` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aktifitas_foto`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aktifitas_foto` (
  `aktifitas` mediumint(8) unsigned NOT NULL,
  `foto` blob NOT NULL,
  `urut` tinyint(3) unsigned NOT NULL,
  KEY `aktifitas` (`aktifitas`),
  CONSTRAINT `aktifitas_foto_ibfk_1` FOREIGN KEY (`aktifitas`) REFERENCES `aktifitas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aktifitas_skor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aktifitas_skor` (
  `aktifitas` mediumint(8) unsigned NOT NULL,
  `tipe` enum('frekuensi','jumlah_peserta') DEFAULT NULL,
  `skor` tinyint(3) unsigned NOT NULL,
  KEY `aktifitas` (`aktifitas`),
  CONSTRAINT `aktifitas_skor_ibfk_1` FOREIGN KEY (`aktifitas`) REFERENCES `aktifitas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bidang`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bidang` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dpd`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dpd` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `halaman`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `halaman` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `nama` varchar(50) DEFAULT NULL,
  `judul` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kategori`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kategori` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `induk_id` smallint(5) unsigned DEFAULT NULL,
  `nama` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`),
  KEY `induk_id` (`induk_id`),
  CONSTRAINT `kategori_ibfk_1` FOREIGN KEY (`induk_id`) REFERENCES `kategori` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kategori_detail`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kategori_detail` (
  `kategori` smallint(5) unsigned NOT NULL,
  `basis` enum('rw') NOT NULL DEFAULT 'rw',
  PRIMARY KEY (`kategori`,`basis`),
  CONSTRAINT `kategori_detail_ibfk_1` FOREIGN KEY (`kategori`) REFERENCES `kategori` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kecamatan`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kecamatan` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `dpd` tinyint(3) unsigned NOT NULL,
  `kode` varchar(5) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kode` (`kode`),
  UNIQUE KEY `nama` (`nama`),
  KEY `dpd` (`dpd`),
  CONSTRAINT `kecamatan_ibfk_1` FOREIGN KEY (`dpd`) REFERENCES `dpd` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kelurahan`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kelurahan` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `kecamatan` tinyint(3) unsigned NOT NULL,
  `kode` varchar(5) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kode` (`kode`),
  UNIQUE KEY `nama` (`nama`),
  KEY `kecamatan` (`kecamatan`),
  CONSTRAINT `kelurahan_ibfk_1` FOREIGN KEY (`kecamatan`) REFERENCES `kecamatan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pemetaan`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pemetaan` (
  `admin_grup` tinyint(3) unsigned NOT NULL,
  `halaman` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`admin_grup`,`halaman`),
  KEY `halaman` (`halaman`),
  CONSTRAINT `pemetaan_ibfk_1` FOREIGN KEY (`admin_grup`) REFERENCES `admin_grup` (`id`),
  CONSTRAINT `pemetaan_ibfk_2` FOREIGN KEY (`halaman`) REFERENCES `halaman` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-12 23:52:20
