USE [Vudyog]
GO
/****** Object:  Table [dbo].[Set_2Way]    Script Date: 06/25/2009 17:40:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Set_2Way](
	[Set_2WayId] [int] IDENTITY(1,1) NOT NULL,
	[cType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Entry_Ty] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sDate] [datetime] NULL,
	[tDate] [datetime] NULL,
	[View_Name] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cFile_path] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cExlude_Field] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Csv_Formula] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsOverWrite] [bit] NULL,
	[MainTbl] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cKeyfield] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF