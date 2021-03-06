USE [InsuranceCompany]
GO
/****** Object:  Table [dbo].[Character]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Character](
	[Code] [varchar](50) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Character] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HouseRisk]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HouseRisk](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Fire_SU] [money] NOT NULL,
	[Premium] [money] NOT NULL,
	[FloorNumber] [smallint] NULL,
	[Detached] [bit] NOT NULL,
	[Flood_SU] [money] NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Policy_ID] [bigint] NOT NULL,
 CONSTRAINT [PK_HouseRisk] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LifeRisk]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LifeRisk](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SU] [money] NOT NULL,
	[Premium] [money] NOT NULL,
	[HazardousOccupation] [bit] NOT NULL,
	[Policy_ID] [bigint] NOT NULL,
 CONSTRAINT [PK_LifeRisk] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Policy]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Policy](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Premium] [money] NOT NULL,
	[Client_ID] [bigint] NOT NULL,
	[Agent_ID] [bigint] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Approved] [bit] NOT NULL,
 CONSTRAINT [PK_Policy] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Policy_ID] [bigint] NOT NULL,
	[Originator_ID] [bigint] NOT NULL,
	[Operator_ID] [bigint] NOT NULL,
	[Status_ID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaskStatus]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskStatus](
	[ID] [varchar](50) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TaskStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[PESEL] [varchar](50) NOT NULL,
	[Character_ID] [varchar](50) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleMake]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleMake](
	[ID] [bigint] NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_VehicleMake] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleModel]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleModel](
	[ID] [bigint] NOT NULL,
	[Make_ID] [bigint] NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Horsepower] [int] NOT NULL,
	[Year] [date] NOT NULL,
 CONSTRAINT [PK_VehicleModel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleRisk]    Script Date: 01.12.2019 12:42:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleRisk](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SU] [money] NOT NULL,
	[Premium] [money] NOT NULL,
	[VehicleModel_ID] [bigint] NOT NULL,
	[ProductionDate] [date] NOT NULL,
	[Mileage] [int] NOT NULL,
	[Policy_ID] [bigint] NOT NULL,
 CONSTRAINT [PK_VehicleRisk] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HouseRisk] ADD  CONSTRAINT [DF_HouseRisk_SU]  DEFAULT ((0)) FOR [Fire_SU]
GO
ALTER TABLE [dbo].[HouseRisk] ADD  CONSTRAINT [DF_HouseRisk_Premium]  DEFAULT ((0)) FOR [Premium]
GO
ALTER TABLE [dbo].[HouseRisk] ADD  CONSTRAINT [DF_HouseRisk_FloorNumber]  DEFAULT (NULL) FOR [FloorNumber]
GO
ALTER TABLE [dbo].[HouseRisk] ADD  CONSTRAINT [DF_HouseRisk_Detached]  DEFAULT ((1)) FOR [Detached]
GO
ALTER TABLE [dbo].[HouseRisk] ADD  CONSTRAINT [DF_HouseRisk_Flood_SU]  DEFAULT ((0)) FOR [Flood_SU]
GO
ALTER TABLE [dbo].[HouseRisk] ADD  CONSTRAINT [DF_HouseRisk_Code]  DEFAULT ('HOUSE') FOR [Code]
GO
ALTER TABLE [dbo].[LifeRisk] ADD  CONSTRAINT [DF_LifeRisk_HazardousOccupation]  DEFAULT ((0)) FOR [HazardousOccupation]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_Character_ID]  DEFAULT ('CLIENT') FOR [Character_ID]
GO
ALTER TABLE [dbo].[HouseRisk]  WITH CHECK ADD  CONSTRAINT [FK_HouseRisk_Policy] FOREIGN KEY([Policy_ID])
REFERENCES [dbo].[Policy] ([ID])
GO
ALTER TABLE [dbo].[HouseRisk] CHECK CONSTRAINT [FK_HouseRisk_Policy]
GO
ALTER TABLE [dbo].[LifeRisk]  WITH CHECK ADD  CONSTRAINT [FK_LifeRisk_Policy] FOREIGN KEY([Policy_ID])
REFERENCES [dbo].[Policy] ([ID])
GO
ALTER TABLE [dbo].[LifeRisk] CHECK CONSTRAINT [FK_LifeRisk_Policy]
GO
ALTER TABLE [dbo].[Policy]  WITH CHECK ADD  CONSTRAINT [FK_Policy_Agent] FOREIGN KEY([Agent_ID])
REFERENCES [dbo].[User] ([ID])
GO
ALTER TABLE [dbo].[Policy] CHECK CONSTRAINT [FK_Policy_Agent]
GO
ALTER TABLE [dbo].[Policy]  WITH CHECK ADD  CONSTRAINT [FK_Policy_Client] FOREIGN KEY([Client_ID])
REFERENCES [dbo].[User] ([ID])
GO
ALTER TABLE [dbo].[Policy] CHECK CONSTRAINT [FK_Policy_Client]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Operator] FOREIGN KEY([Operator_ID])
REFERENCES [dbo].[User] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_Operator]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Originator] FOREIGN KEY([Originator_ID])
REFERENCES [dbo].[User] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_Originator]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Policy] FOREIGN KEY([Policy_ID])
REFERENCES [dbo].[Policy] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_Policy]
GO
ALTER TABLE [dbo].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_TaskStatus] FOREIGN KEY([Status_ID])
REFERENCES [dbo].[TaskStatus] ([ID])
GO
ALTER TABLE [dbo].[Task] CHECK CONSTRAINT [FK_Task_TaskStatus]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Character] FOREIGN KEY([Character_ID])
REFERENCES [dbo].[Character] ([Code])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Character]
GO
ALTER TABLE [dbo].[VehicleModel]  WITH CHECK ADD  CONSTRAINT [FK_VehicleModel_VehicleMake] FOREIGN KEY([Make_ID])
REFERENCES [dbo].[VehicleMake] ([ID])
GO
ALTER TABLE [dbo].[VehicleModel] CHECK CONSTRAINT [FK_VehicleModel_VehicleMake]
GO
ALTER TABLE [dbo].[VehicleRisk]  WITH CHECK ADD  CONSTRAINT [FK_VehicleRisk_Policy] FOREIGN KEY([Policy_ID])
REFERENCES [dbo].[Policy] ([ID])
GO
ALTER TABLE [dbo].[VehicleRisk] CHECK CONSTRAINT [FK_VehicleRisk_Policy]
GO
ALTER TABLE [dbo].[VehicleRisk]  WITH CHECK ADD  CONSTRAINT [FK_VehicleRisk_VehicleModel] FOREIGN KEY([VehicleModel_ID])
REFERENCES [dbo].[VehicleModel] ([ID])
GO
ALTER TABLE [dbo].[VehicleRisk] CHECK CONSTRAINT [FK_VehicleRisk_VehicleModel]
GO
