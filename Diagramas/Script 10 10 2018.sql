/*    ==ScriptingParameters==

    SourceServerVersion : SQL Server 2016 (13.0.4001)
    SourceDatabaseEngineEdition : Microsoft SQL Server Standard Edition
    SourceDatabaseEngineType : SQL Server independiente

    TargetServerVersion : SQL Server 2008 R2
    TargetDatabaseEngineEdition : Microsoft SQL Server Standard Edition
    TargetDatabaseEngineType : SQL Server independiente
*/

USE [Demo]
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Usuario_Login2]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Usuario_Login2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Seguridad].[usp_Usuario_Login2]
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Usuario_Login]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Usuario_Login]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Seguridad].[usp_Usuario_Login]
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_Registrar]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_Registrar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Seguridad].[usp_Rol_Registrar]
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_ObtenerPorId]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_ObtenerPorId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Seguridad].[usp_Rol_ObtenerPorId]
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_Obtener]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_Obtener]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Seguridad].[usp_Rol_Obtener]
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_Modificar]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_Modificar]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Seguridad].[usp_Rol_Modificar]
GO
/****** Object:  StoredProcedure [Maestro].[usp_Provincia_Combo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Provincia_Combo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Maestro].[usp_Provincia_Combo]
GO
/****** Object:  StoredProcedure [Maestro].[usp_Pais_Combo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Pais_Combo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Maestro].[usp_Pais_Combo]
GO
/****** Object:  StoredProcedure [Maestro].[usp_Estado_Combo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Estado_Combo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Maestro].[usp_Estado_Combo]
GO
/****** Object:  StoredProcedure [Maestro].[usp_Distrito_Combo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Distrito_Combo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Maestro].[usp_Distrito_Combo]
GO
/****** Object:  StoredProcedure [Maestro].[usp_Departamento_Combo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Departamento_Combo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Maestro].[usp_Departamento_Combo]
GO
/****** Object:  StoredProcedure [Maestro].[usp_Cliente_Obtener]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Cliente_Obtener]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Maestro].[usp_Cliente_Obtener]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[DF__Usuario__Elimina__4F7CD00D]') AND type = 'D')
BEGIN
ALTER TABLE [Seguridad].[Usuario] DROP CONSTRAINT [DF__Usuario__Elimina__4F7CD00D]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguimiento].[DF__Correo__Enviado__0D7A0286]') AND type = 'D')
BEGIN
ALTER TABLE [Seguimiento].[Correo] DROP CONSTRAINT [DF__Correo__Enviado__0D7A0286]
END
GO
/****** Object:  Table [Seguridad].[Usuario]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[Usuario]') AND type in (N'U'))
DROP TABLE [Seguridad].[Usuario]
GO
/****** Object:  Table [Seguridad].[RolUsuario]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[RolUsuario]') AND type in (N'U'))
DROP TABLE [Seguridad].[RolUsuario]
GO
/****** Object:  Table [Seguridad].[Rol]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[Rol]') AND type in (N'U'))
DROP TABLE [Seguridad].[Rol]
GO
/****** Object:  Table [Seguimiento].[Correo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguimiento].[Correo]') AND type in (N'U'))
DROP TABLE [Seguimiento].[Correo]
GO
/****** Object:  Table [Maestro].[TipoEstado]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[TipoEstado]') AND type in (N'U'))
DROP TABLE [Maestro].[TipoEstado]
GO
/****** Object:  Table [Maestro].[TipoCorreo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[TipoCorreo]') AND type in (N'U'))
DROP TABLE [Maestro].[TipoCorreo]
GO
/****** Object:  Table [Maestro].[Provincia]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Provincia]') AND type in (N'U'))
DROP TABLE [Maestro].[Provincia]
GO
/****** Object:  Table [Maestro].[Prioridad]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Prioridad]') AND type in (N'U'))
DROP TABLE [Maestro].[Prioridad]
GO
/****** Object:  Table [Maestro].[Pais]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Pais]') AND type in (N'U'))
DROP TABLE [Maestro].[Pais]
GO
/****** Object:  Table [Maestro].[Motivo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Motivo]') AND type in (N'U'))
DROP TABLE [Maestro].[Motivo]
GO
/****** Object:  Table [Maestro].[Estado]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Estado]') AND type in (N'U'))
DROP TABLE [Maestro].[Estado]
GO
/****** Object:  Table [Maestro].[Distrito]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Distrito]') AND type in (N'U'))
DROP TABLE [Maestro].[Distrito]
GO
/****** Object:  Table [Maestro].[Departamento]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Departamento]') AND type in (N'U'))
DROP TABLE [Maestro].[Departamento]
GO
/****** Object:  Table [Maestro].[Contacto]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Contacto]') AND type in (N'U'))
DROP TABLE [Maestro].[Contacto]
GO
/****** Object:  Table [Maestro].[Cliente]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Cliente]') AND type in (N'U'))
DROP TABLE [Maestro].[Cliente]
GO
/****** Object:  Table [Maestro].[Area]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Area]') AND type in (N'U'))
DROP TABLE [Maestro].[Area]
GO
/****** Object:  Table [Gestion].[IncidenciaDetalleAdjunto]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[IncidenciaDetalleAdjunto]') AND type in (N'U'))
DROP TABLE [Gestion].[IncidenciaDetalleAdjunto]
GO
/****** Object:  Table [Gestion].[IncidenciaDetalle]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[IncidenciaDetalle]') AND type in (N'U'))
DROP TABLE [Gestion].[IncidenciaDetalle]
GO
/****** Object:  Table [Gestion].[Incidencia]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[Incidencia]') AND type in (N'U'))
DROP TABLE [Gestion].[Incidencia]
GO
/****** Object:  Table [Gestion].[FaqDetalleAdjunto]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[FaqDetalleAdjunto]') AND type in (N'U'))
DROP TABLE [Gestion].[FaqDetalleAdjunto]
GO
/****** Object:  Table [Gestion].[FaqDetalle]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[FaqDetalle]') AND type in (N'U'))
DROP TABLE [Gestion].[FaqDetalle]
GO
/****** Object:  Table [Gestion].[Faq]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[Faq]') AND type in (N'U'))
DROP TABLE [Gestion].[Faq]
GO
/****** Object:  Table [Configuracion].[Parametro]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Configuracion].[Parametro]') AND type in (N'U'))
DROP TABLE [Configuracion].[Parametro]
GO
/****** Object:  Schema [Seguridad]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Seguridad')
DROP SCHEMA [Seguridad]
GO
/****** Object:  Schema [Seguimiento]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Seguimiento')
DROP SCHEMA [Seguimiento]
GO
/****** Object:  Schema [Maestro]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Maestro')
DROP SCHEMA [Maestro]
GO
/****** Object:  Schema [Gestion]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Gestion')
DROP SCHEMA [Gestion]
GO
/****** Object:  Schema [Configuracion]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Configuracion')
DROP SCHEMA [Configuracion]
GO
/****** Object:  Schema [Auditoria]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'Auditoria')
DROP SCHEMA [Auditoria]
GO
USE [master]
GO
/****** Object:  Database [Demo]    Script Date: 10/10/2018 06:51:39 ******/
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'Demo')
DROP DATABASE [Demo]
GO
/****** Object:  Database [Demo]    Script Date: 10/10/2018 06:51:39 ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Demo')
BEGIN
CREATE DATABASE [Demo] ON  PRIMARY 
( NAME = N'Demo', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Demo.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Demo_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\Demo_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
END
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Demo].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Demo] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Demo] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Demo] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Demo] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Demo] SET ARITHABORT OFF 
GO
ALTER DATABASE [Demo] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Demo] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Demo] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Demo] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Demo] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Demo] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Demo] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Demo] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Demo] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Demo] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Demo] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Demo] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Demo] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Demo] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Demo] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Demo] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Demo] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Demo] SET RECOVERY FULL 
GO
ALTER DATABASE [Demo] SET  MULTI_USER 
GO
ALTER DATABASE [Demo] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Demo] SET DB_CHAINING OFF 
GO
USE [Demo]
GO
/****** Object:  Schema [Auditoria]    Script Date: 10/10/2018 06:51:39 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Auditoria')
EXEC sys.sp_executesql N'CREATE SCHEMA [Auditoria]'
GO
/****** Object:  Schema [Configuracion]    Script Date: 10/10/2018 06:51:39 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Configuracion')
EXEC sys.sp_executesql N'CREATE SCHEMA [Configuracion]'
GO
/****** Object:  Schema [Gestion]    Script Date: 10/10/2018 06:51:39 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Gestion')
EXEC sys.sp_executesql N'CREATE SCHEMA [Gestion]'
GO
/****** Object:  Schema [Maestro]    Script Date: 10/10/2018 06:51:39 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Maestro')
EXEC sys.sp_executesql N'CREATE SCHEMA [Maestro]'
GO
/****** Object:  Schema [Seguimiento]    Script Date: 10/10/2018 06:51:39 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Seguimiento')
EXEC sys.sp_executesql N'CREATE SCHEMA [Seguimiento]'
GO
/****** Object:  Schema [Seguridad]    Script Date: 10/10/2018 06:51:39 ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'Seguridad')
EXEC sys.sp_executesql N'CREATE SCHEMA [Seguridad]'
GO
/****** Object:  Table [Configuracion].[Parametro]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Configuracion].[Parametro]') AND type in (N'U'))
BEGIN
CREATE TABLE [Configuracion].[Parametro](
	[IdParametro] [int] NULL,
	[Propiedad] [varchar](250) NULL,
	[Valor] [varchar](500) NULL,
	[Observacion] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [Gestion].[Faq]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[Faq]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gestion].[Faq](
	[IdFaq] [int] IDENTITY(1,1) NOT NULL,
	[Titulo] [varchar](250) NULL,
	[IdCliente] [int] NULL,
	[IdContacto] [int] NULL,
	[IdUsuarioRegistro] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[FechaActualizacion] [datetime] NULL,
	[IdEstado] [int] NULL,
	[IdPrioridad] [int] NULL,
	[IdMotivo] [int] NULL,
	[IdArea] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gestion].[FaqDetalle]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[FaqDetalle]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gestion].[FaqDetalle](
	[IdFaqDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdFaq] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[Descripcion] [nvarchar](max) NULL,
	[IdUsuario] [int] NULL,
	[IdArea] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [Gestion].[FaqDetalleAdjunto]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[FaqDetalleAdjunto]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gestion].[FaqDetalleAdjunto](
	[IdFaqDetalleAdjunto] [int] IDENTITY(1,1) NOT NULL,
	[IdFaqDetalle] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[NombreArchivo] [varchar](250) NULL,
	[Extension] [varchar](100) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gestion].[Incidencia]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[Incidencia]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gestion].[Incidencia](
	[IdIncidencia] [int] IDENTITY(1,1) NOT NULL,
	[IdCliente] [int] NULL,
	[Asunto] [varchar](500) NULL,
	[IdTipoIncidencia] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[FechaFinalizacion] [datetime] NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gestion].[IncidenciaDetalle]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[IncidenciaDetalle]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gestion].[IncidenciaDetalle](
	[IdIncidenciaDetalle] [int] IDENTITY(1,1) NOT NULL,
	[IdIncidencia] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Gestion].[IncidenciaDetalleAdjunto]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Gestion].[IncidenciaDetalleAdjunto]') AND type in (N'U'))
BEGIN
CREATE TABLE [Gestion].[IncidenciaDetalleAdjunto](
	[IdIncidenciaDetalleAdjunto] [int] IDENTITY(1,1) NOT NULL,
	[IdIncidenciaDetalle] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[NombreArchivo] [varchar](250) NULL,
	[Extension] [varchar](100) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Area]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Area]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Area](
	[IdArea] [int] NULL,
	[Nombre] [varchar](100) NULL,
	[Observacion] [varchar](250) NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Cliente]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Cliente]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Cliente](
	[IdCliente] [int] IDENTITY(1,1) NOT NULL,
	[NumeroDocumento] [varchar](20) NULL,
	[RazonSocial] [varchar](250) NULL,
	[Direccion] [varchar](250) NULL,
	[IdPais] [int] NULL,
	[IdDepartamento] [int] NULL,
	[IdProvincia] [int] NULL,
	[IdDistrito] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[IdUsuario] [int] NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Contacto]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Contacto]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Contacto](
	[IdContacto] [int] NOT NULL,
	[Nombre] [varchar](250) NULL,
	[Apellido] [varchar](250) NULL,
	[Correo] [varchar](250) NULL,
	[Telefono] [varchar](50) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Departamento]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Departamento]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Departamento](
	[IdDepartamento] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NULL,
	[Codigo] [varchar](20) NULL,
	[IdPais] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Distrito]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Distrito]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Distrito](
	[IdDistrito] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NULL,
	[Codigo] [varchar](20) NULL,
	[IdProvincia] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Estado]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Estado]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Estado](
	[IdEstado] [int] NULL,
	[Nombre] [varchar](100) NULL,
	[Observacion] [varchar](500) NULL,
	[IdTipoEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Motivo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Motivo]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Motivo](
	[IdPrioridad] [int] NULL,
	[Abreviatura] [varchar](100) NULL,
	[Nombre] [varchar](250) NULL,
	[Observacion] [varchar](250) NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Pais]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Pais]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Pais](
	[IdPais] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NULL,
	[Codigo] [varchar](20) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Prioridad]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Prioridad]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Prioridad](
	[IdPrioridad] [int] NULL,
	[Nombre] [varchar](100) NULL,
	[Observacion] [varchar](250) NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[Provincia]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[Provincia]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[Provincia](
	[IdProvincia] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NULL,
	[Codigo] [varchar](20) NULL,
	[IdDepartamento] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[TipoCorreo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[TipoCorreo]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[TipoCorreo](
	[IdTipoCorreo] [int] NULL,
	[Nombre] [varchar](100) NULL,
	[Observacion] [varchar](250) NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Maestro].[TipoEstado]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[TipoEstado]') AND type in (N'U'))
BEGIN
CREATE TABLE [Maestro].[TipoEstado](
	[IdTipoEstado] [int] NULL,
	[Nombre] [varchar](100) NULL,
	[Observacion] [varchar](500) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Seguimiento].[Correo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguimiento].[Correo]') AND type in (N'U'))
BEGIN
CREATE TABLE [Seguimiento].[Correo](
	[IdCorreo] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoCorreo] [int] NULL,
	[Destinatario] [varchar](500) NULL,
	[Copia] [varchar](500) NULL,
	[Asunto] [varchar](250) NULL,
	[Cuerpo] [nvarchar](max) NULL,
	[Enviado] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [Seguridad].[Rol]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[Rol]') AND type in (N'U'))
BEGIN
CREATE TABLE [Seguridad].[Rol](
	[IdRol] [int] NULL,
	[Nombre] [varchar](100) NULL,
	[Observacion] [varchar](500) NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Seguridad].[RolUsuario]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[RolUsuario]') AND type in (N'U'))
BEGIN
CREATE TABLE [Seguridad].[RolUsuario](
	[IdRolUsuario] [int] NULL,
	[IdRol] [int] NULL,
	[IdUsuario] [int] NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [Seguridad].[Usuario]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[Usuario]') AND type in (N'U'))
BEGIN
CREATE TABLE [Seguridad].[Usuario](
	[IdUsuario] [int] NULL,
	[UserName] [varchar](50) NULL,
	[Contrasenia] [nvarchar](max) NULL,
	[Nombre] [varchar](50) NULL,
	[ApellidoPaterno] [varchar](50) NULL,
	[ApellidoMaterno] [varchar](50) NULL,
	[Eliminado] [bit] NULL,
	[IdEstado] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET IDENTITY_INSERT [Maestro].[Cliente] ON 
GO
INSERT [Maestro].[Cliente] ([IdCliente], [NumeroDocumento], [RazonSocial], [Direccion], [IdPais], [IdDepartamento], [IdProvincia], [IdDistrito], [FechaRegistro], [IdUsuario], [IdEstado]) VALUES (1, N'11111111111', N'Frank1', N'Avenida Los Olivos', 1, 1, 1, 1, CAST(N'2018-10-08T00:00:00.000' AS DateTime), 1, 1)
GO
INSERT [Maestro].[Cliente] ([IdCliente], [NumeroDocumento], [RazonSocial], [Direccion], [IdPais], [IdDepartamento], [IdProvincia], [IdDistrito], [FechaRegistro], [IdUsuario], [IdEstado]) VALUES (2, N'22222222222', N'Frank2', N'Jiron Los Olivos', 1, 1, 1, 1, CAST(N'2018-10-08T00:00:00.000' AS DateTime), 1, 1)
GO
SET IDENTITY_INSERT [Maestro].[Cliente] OFF
GO
SET IDENTITY_INSERT [Maestro].[Departamento] ON 
GO
INSERT [Maestro].[Departamento] ([IdDepartamento], [Nombre], [Codigo], [IdPais]) VALUES (1, N'Lima', N'01', 1)
GO
SET IDENTITY_INSERT [Maestro].[Departamento] OFF
GO
SET IDENTITY_INSERT [Maestro].[Distrito] ON 
GO
INSERT [Maestro].[Distrito] ([IdDistrito], [Nombre], [Codigo], [IdProvincia]) VALUES (1, N'Los Olivos', N'39', 1)
GO
SET IDENTITY_INSERT [Maestro].[Distrito] OFF
GO
INSERT [Maestro].[Estado] ([IdEstado], [Nombre], [Observacion], [IdTipoEstado]) VALUES (1, N'Activo', NULL, 1)
GO
INSERT [Maestro].[Estado] ([IdEstado], [Nombre], [Observacion], [IdTipoEstado]) VALUES (2, N'Inactivo', NULL, 1)
GO
SET IDENTITY_INSERT [Maestro].[Pais] ON 
GO
INSERT [Maestro].[Pais] ([IdPais], [Nombre], [Codigo]) VALUES (1, N'Perú', N'51')
GO
SET IDENTITY_INSERT [Maestro].[Pais] OFF
GO
SET IDENTITY_INSERT [Maestro].[Provincia] ON 
GO
INSERT [Maestro].[Provincia] ([IdProvincia], [Nombre], [Codigo], [IdDepartamento]) VALUES (1, N'Lima', N'01', 1)
GO
SET IDENTITY_INSERT [Maestro].[Provincia] OFF
GO
INSERT [Maestro].[TipoEstado] ([IdTipoEstado], [Nombre], [Observacion]) VALUES (1, N'Maestros', N'Usado para los mantenimientos en general')
GO
INSERT [Seguridad].[Rol] ([IdRol], [Nombre], [Observacion], [IdEstado]) VALUES (1, N'Administrador Sistema', NULL, 1)
GO
INSERT [Seguridad].[Rol] ([IdRol], [Nombre], [Observacion], [IdEstado]) VALUES (2, N'Ventas', NULL, 1)
GO
INSERT [Seguridad].[Rol] ([IdRol], [Nombre], [Observacion], [IdEstado]) VALUES (3, N'Contabilidad', N'Nada por aca', 1)
GO
INSERT [Seguridad].[Rol] ([IdRol], [Nombre], [Observacion], [IdEstado]) VALUES (4, N'Nuevo Rol', N'Nueva Observacion', 1)
GO
INSERT [Seguridad].[Rol] ([IdRol], [Nombre], [Observacion], [IdEstado]) VALUES (5, N'Nuevo Rol 5', NULL, 1)
GO
INSERT [Seguridad].[Rol] ([IdRol], [Nombre], [Observacion], [IdEstado]) VALUES (6, N'Nuevo Rol 6', NULL, 1)
GO
INSERT [Seguridad].[Rol] ([IdRol], [Nombre], [Observacion], [IdEstado]) VALUES (7, N'Nuevo Rol 7 Modificado', N'Nueva Descripcion', 1)
GO
INSERT [Seguridad].[RolUsuario] ([IdRolUsuario], [IdRol], [IdUsuario], [IdEstado]) VALUES (1, 1, 1, 1)
GO
INSERT [Seguridad].[RolUsuario] ([IdRolUsuario], [IdRol], [IdUsuario], [IdEstado]) VALUES (2, 2, 1, 1)
GO
INSERT [Seguridad].[Usuario] ([IdUsuario], [UserName], [Contrasenia], [Nombre], [ApellidoPaterno], [ApellidoMaterno], [Eliminado], [IdEstado]) VALUES (1, N'fcochachin', N'123456', N'Frank', N'Cochachin', N'Quito', 0, 1)
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguimiento].[DF__Correo__Enviado__0D7A0286]') AND type = 'D')
BEGIN
ALTER TABLE [Seguimiento].[Correo] ADD  DEFAULT ((0)) FOR [Enviado]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[DF__Usuario__Elimina__4F7CD00D]') AND type = 'D')
BEGIN
ALTER TABLE [Seguridad].[Usuario] ADD  DEFAULT ((0)) FOR [Eliminado]
END
GO
/****** Object:  StoredProcedure [Maestro].[usp_Cliente_Obtener]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Cliente_Obtener]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Maestro].[usp_Cliente_Obtener] AS' 
END
GO

ALTER PROCEDURE [Maestro].[usp_Cliente_Obtener] --'','',1,1,10,'RazonSocial','asc'
	@NumeroDocumento VARCHAR(20)=''
	,@RazonSocial VARCHAR(250)=''
	,@IdEstado INT
	,@NumeroPagina INT
	,@CantidadRegistros INT
	,@ColumnaOrden VARCHAR(100) = 'IdCliente'
	,@DireccionOrden VARCHAR(10)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @Desde INT
	DECLARE @Hasta INT
	SET @Desde = ( @NumeroPagina - 1 ) * @CantidadRegistros 
	SET @Hasta = ( @NumeroPagina * @CantidadRegistros ) + 1
	
	SELECT	Item,
			IdCliente,
			NumeroDocumento,
			RazonSocial,
			Direccion,
			IdEstado,
			Estado
	FROM 
	(
		SELECT
			ROW_NUMBER()OVER(ORDER BY
					(CASE WHEN @ColumnaOrden = 'IdCliente' AND @DireccionOrden = 'desc' THEN  cli.IdCliente END) DESC,
					(CASE WHEN @ColumnaOrden = 'IdCliente' AND @DireccionOrden = 'asc' THEN cli.IdCliente END) ASC,
					(CASE WHEN @ColumnaOrden = 'NumeroDocumento' AND @DireccionOrden = 'desc' THEN cli.NumeroDocumento END) DESC,
					(CASE WHEN @ColumnaOrden = 'NumeroDocumento' AND @DireccionOrden = 'asc' THEN cli.NumeroDocumento  END) ASC,
					(CASE WHEN @ColumnaOrden = 'RazonSocial' AND @DireccionOrden = 'desc' THEN cli.RazonSocial END) DESC,
					(CASE WHEN @ColumnaOrden = 'RazonSocial' AND @DireccionOrden = 'asc' THEN cli.RazonSocial  END) ASC,
					(CASE WHEN @ColumnaOrden = 'Direccion' AND @DireccionOrden = 'desc' THEN cli.Direccion END) DESC,
					(CASE WHEN @ColumnaOrden = 'Direccion' AND @DireccionOrden = 'asc' THEN cli.Direccion  END) ASC
			) AS Item 
			,cli.IdCliente
			,cli.NumeroDocumento
			,cli.RazonSocial
			,cli.Direccion
			,cli.IdEstado
			,est.Nombre Estado
		FROM Maestro.Cliente cli
		INNER JOIN Maestro.Estado est ON cli.IdEstado = est.IdEstado
		WHERE cli.NumeroDocumento LIKE '%' + ISNULL(@NumeroDocumento,'') + '%'
			AND cli.RazonSocial LIKE '%' + ISNULL(@RazonSocial,'') + '%'
			AND cli.IdEstado = CASE @IdEstado
								WHEN 0
									THEN cli.IdEstado
								ELSE @IdEstado
							  END
	) AS Resultado
	WHERE Item > @Desde AND Item < @Hasta
	
	SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [Maestro].[usp_Departamento_Combo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Departamento_Combo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Maestro].[usp_Departamento_Combo] AS' 
END
GO
ALTER PROCEDURE [Maestro].[usp_Departamento_Combo]
@IdPais INT
AS
BEGIN
	SELECT IdDepartamento, Nombre FROM Maestro.Departamento
	WHERE IdPais = @IdPais
	ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [Maestro].[usp_Distrito_Combo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Distrito_Combo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Maestro].[usp_Distrito_Combo] AS' 
END
GO
ALTER PROCEDURE [Maestro].[usp_Distrito_Combo]
@IdProvincia INT
AS
BEGIN
	SELECT IdDistrito, Nombre FROM Maestro.Distrito
	WHERE IdProvincia = @IdProvincia
	ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [Maestro].[usp_Estado_Combo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Estado_Combo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Maestro].[usp_Estado_Combo] AS' 
END
GO
ALTER PROCEDURE [Maestro].[usp_Estado_Combo] --1
@IdTipoEstado INT
AS
BEGIN
	SELECT IdEstado, Nombre FROM Maestro.Estado WHERE IdTipoEstado = @IdTipoEstado
	ORDER BY IdEstado
END
GO
/****** Object:  StoredProcedure [Maestro].[usp_Pais_Combo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Pais_Combo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Maestro].[usp_Pais_Combo] AS' 
END
GO
ALTER PROCEDURE [Maestro].[usp_Pais_Combo]
AS
BEGIN
	SELECT IdPais, Nombre FROM Maestro.Pais
	ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [Maestro].[usp_Provincia_Combo]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Maestro].[usp_Provincia_Combo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Maestro].[usp_Provincia_Combo] AS' 
END
GO
ALTER PROCEDURE [Maestro].[usp_Provincia_Combo]
@IdDepartamento INT
AS
BEGIN
	SELECT IdProvincia, Nombre FROM Maestro.Provincia
	WHERE IdDepartamento = @IdDepartamento
	ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_Modificar]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_Modificar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Seguridad].[usp_Rol_Modificar] AS' 
END
GO
ALTER PROCEDURE [Seguridad].[usp_Rol_Modificar]
@IdRol INT,
@Nombre VARCHAR(100),
@Observacion VARCHAR(500) = NULL,
@IdEstado INT
AS
BEGIN
	UPDATE Seguridad.Rol
	SET Nombre = @Nombre, 
		Observacion = @Observacion, 
		IdEstado = @IdEstado
	WHERE IdRol = @IdRol
END
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_Obtener]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_Obtener]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Seguridad].[usp_Rol_Obtener] AS' 
END
GO

ALTER PROCEDURE [Seguridad].[usp_Rol_Obtener] --'',1,1,10,'Nombre','desc'
	@Nombre VARCHAR(100)=''
	,@IdEstado INT
	,@NumeroPagina INT
	,@CantidadRegistros INT
	,@ColumnaOrden VARCHAR(100) = 'IdRol'
	,@DireccionOrden VARCHAR(10)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @Desde INT
	DECLARE @Hasta INT
	SET @Desde = ( @NumeroPagina - 1 ) * @CantidadRegistros 
	SET @Hasta = ( @NumeroPagina * @CantidadRegistros ) + 1
	
	SELECT	Item,
			IdRol,
			Nombre,
			Observacion,
			IdEstado,
			Estado
	FROM 
	(
		SELECT
			ROW_NUMBER()OVER(ORDER BY
					(CASE WHEN @ColumnaOrden = 'IdRol' AND @DireccionOrden = 'desc' THEN  ro.IdRol END) DESC,
					(CASE WHEN @ColumnaOrden = 'IdRol' AND @DireccionOrden = 'asc' THEN ro.IdRol END) ASC,
					(CASE WHEN @ColumnaOrden = 'Nombre' AND @DireccionOrden = 'desc' THEN ro.Nombre END) DESC,
					(CASE WHEN @ColumnaOrden = 'Nombre' AND @DireccionOrden = 'asc' THEN ro.Nombre  END) ASC,
					(CASE WHEN @ColumnaOrden = 'Observacion' AND @DireccionOrden = 'desc' THEN ro.Observacion END) DESC,
					(CASE WHEN @ColumnaOrden = 'Observacion' AND @DireccionOrden = 'asc' THEN ro.Observacion  END) ASC
			) AS Item 
			,ro.IdRol
			,ro.Nombre
			,ro.Observacion
			,ro.IdEstado
			,est.Nombre Estado
		FROM Seguridad.Rol ro
		INNER JOIN Maestro.Estado est ON ro.IdEstado = est.IdEstado
		WHERE ro.Nombre LIKE '%' + ISNULL(@Nombre,'') + '%'
			AND ro.IdEstado = CASE @IdEstado
								WHEN 0
									THEN ro.IdEstado
								ELSE @IdEstado
							  END
	) AS Resultado
	WHERE Item > @Desde AND Item < @Hasta
	
	SET NOCOUNT OFF;

END
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_ObtenerPorId]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_ObtenerPorId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Seguridad].[usp_Rol_ObtenerPorId] AS' 
END
GO
ALTER PROCEDURE [Seguridad].[usp_Rol_ObtenerPorId] --1
	@IdRol INT
AS
BEGIN
	SELECT ro.IdRol
		,ro.Nombre
		,ro.Observacion
		,ro.IdEstado
		,est.Nombre Estado
	FROM Seguridad.Rol ro
	INNER JOIN Maestro.Estado est ON ro.IdEstado = est.IdEstado
	WHERE ro.IdRol = @IdRol
END
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Rol_Registrar]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Rol_Registrar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Seguridad].[usp_Rol_Registrar] AS' 
END
GO
ALTER PROCEDURE [Seguridad].[usp_Rol_Registrar]
@IdRol INT,
@Nombre VARCHAR(100),
@Observacion VARCHAR(500) = NULL,
@IdEstado INT
AS
BEGIN
	INSERT INTO Seguridad.Rol(IdRol, Nombre, Observacion, IdEstado)
	VALUES(@IdRol, @Nombre, @Observacion, @IdEstado)
END
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Usuario_Login]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Usuario_Login]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Seguridad].[usp_Usuario_Login] AS' 
END
GO
ALTER PROCEDURE [Seguridad].[usp_Usuario_Login] --'fcochachin','123456'
	@UserName VARCHAR(50)
	,@Contrasenia NVARCHAR(MAX)
AS
BEGIN
	SELECT	usu.IdUsuario,
			usu.UserName,
			usu.Nombre,
			usu.ApellidoPaterno,
			usu.ApellidoMaterno,
			rolUsu.IdRolUsuario,
			rolUsu.IdUsuario,
			rolUsu.IdRol,
			ro.Nombre NombreRol
	FROM Seguridad.Usuario usu
	INNER JOIN Seguridad.RolUsuario rolUsu ON usu.IdUsuario = rolUsu.IdUsuario
	INNER JOIN Seguridad.Rol ro ON rolUsu.IdRol = ro.IdRol
	WHERE usu.UserName = @UserName
		AND usu.Contrasenia = @Contrasenia
		AND usu.IdEstado = 1
		AND usu.Eliminado = 0
		AND rolUsu.IdEstado = 1
		AND ro.IdEstado = 1
END
GO
/****** Object:  StoredProcedure [Seguridad].[usp_Usuario_Login2]    Script Date: 10/10/2018 06:51:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Seguridad].[usp_Usuario_Login2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Seguridad].[usp_Usuario_Login2] AS' 
END
GO

ALTER PROCEDURE [Seguridad].[usp_Usuario_Login2] --'fcochachin','123456'
	@UserName VARCHAR(50)
	,@Contrasenia NVARCHAR(MAX)
AS
BEGIN
	SELECT	usu.IdUsuario,
			usu.UserName,
			usu.Nombre,
			usu.ApellidoPaterno,
			usu.ApellidoMaterno	
	FROM Seguridad.Usuario usu
	WHERE usu.UserName = @UserName
		AND usu.Contrasenia = @Contrasenia
		AND usu.IdEstado = 1
		AND usu.Eliminado = 0

	SELECT	rolUsu.IdRolUsuario,
			rolUsu.IdUsuario,
			rolUsu.IdRol,
			ro.Nombre NombreRol
	FROM Seguridad.Usuario usu
	INNER JOIN Seguridad.RolUsuario rolUsu ON usu.IdUsuario = rolUsu.IdUsuario
	INNER JOIN Seguridad.Rol ro ON rolUsu.IdRol = ro.IdRol
	WHERE usu.UserName = @UserName
		AND usu.Contrasenia = @Contrasenia
		AND usu.IdEstado = 1
		AND usu.Eliminado = 0
		AND rolUsu.IdEstado = 1
		AND ro.IdEstado = 1
END
GO
USE [master]
GO
ALTER DATABASE [Demo] SET  READ_WRITE 
GO
