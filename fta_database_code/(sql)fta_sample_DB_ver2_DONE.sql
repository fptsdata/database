CREATE DATABASE fta_sample2
go

use fta_sample2
go

/*CREATE SCHEMA Electricity
go

CREATE TABLE Electricity.Daily_output
(
  ID          varchar(10),
  report_date date       ,
  Pmax        float      ,
  Q_total     float      ,
  Thuy_dien   float      ,
  Than        float      ,
  Khi         float      ,
  Dau         float      ,
  DMT         float      ,
  Gio         float      ,
  Nhap_khau   float      ,
  Khac        float      ,
  last_update date       
)
GO*/

CREATE SCHEMA fdata
GO

CREATE TABLE fdata.EOD
(
  tranID      varchar(100) NOT NULL,
  ticker      varchar(10)  NOT NULL,
  openP       float       ,
  highP       float       ,
  lowP        float       ,
  closeP      float       ,
  volume      bigint      ,
  date_report date        ,
  last_update date        ,
  CONSTRAINT PK_fdata_EOD PRIMARY KEY (tranID)
)
GO

CREATE TABLE freefloat
(
  ffID        varchar(20) NOT NULL,
  ticker      varchar(10) NOT NULL,
  date_report date       ,
  freefloat   float      ,
  last_update date       ,
  CONSTRAINT PK_freefloat PRIMARY KEY (ffID)
)
GO

CREATE SCHEMA InfoB_BasicIndicator
go

CREATE TABLE InfoB_BasicIndicator.stock
(
  biID                           varchar(20)    NOT NULL,
  ticker                         varchar(10)    NOT NULL,
  recordHigh52Week               float         ,
  recordLow52Week                float         ,
  averageOutstandingShares       bigint        ,
  primaryEPS                     float         ,
  notes                          NVARCHAR(1000),
  adjRatio1                      float         ,
  notes1                         NVARCHAR(1000),
  adjRatio2                      float         ,
  notes2                         VARCHAR(1000) ,
  adjustedEPS                    float         ,
  marketPrice                    float         ,
  PE                             float         ,
  dividend                       float         ,
  divPerMarketPrice              float         ,
  ROA                            float         ,
  ROE                            float         ,
  listedShares                   bigint        ,
  outstandingShares              bigint        ,
  changeOutstandingSharesPercent float         ,
  adjustedOutstandingShares      bigint        ,
  turnoverRatio                  float         ,
  report_date                    date          ,
  last_update                    date          ,
  CONSTRAINT PK_InfoB_BasicIndicator_stock PRIMARY KEY (biID)
)
GO

CREATE SCHEMA InfoB_CommonStock
go


CREATE TABLE InfoB_CommonStock.Category
(
  ticker      varchar(10)    NOT NULL,
  GICS3       nvarchar(200) NOT NULL,
  last_update date          
)
GO

CREATE TABLE InfoB_CommonStock.CategoryList
(
  GICS3       nvarchar(200) NOT NULL,
  GICS2       nvarchar(1000),
  GICS1       nvarchar(1000),
  last_update date          ,
  CONSTRAINT PK_InfoB_CommonStock_CategoryList PRIMARY KEY (GICS3)
)
GO

CREATE TABLE InfoB_CommonStock.companyName
(
  ticker      varchar(10)   NOT NULL,
  VnName      nvarchar(500),
  last_update date         ,
  CONSTRAINT PK_InfoB_CommonStock_companyName PRIMARY KEY (ticker)
)
GO

CREATE TABLE InfoB_CommonStock.Sector
(
  ticker      varchar(10) NOT NULL,
  exchange    varchar(5) ,
  last_update date       
)
GO

CREATE SCHEMA InfoB_ForeignTrading
go


CREATE TABLE InfoB_ForeignTrading.stock
(
  ftID                    varchar(20) NOT NULL,
  ticker                  varchar(10) NOT NULL,
  totalRoom               float      ,
  currentRoom             float      ,
  foreignOwnedRatio       float      ,
  stateOwnedRatio         float      ,
  omPreOpenBuyingVolume   bigint     ,
  omContBuyingVolume      bigint     ,
  omPreCloseBuyingVolume  bigint     ,
  omBuyingValue           float      ,
  omPreOpenSellingVolume  bigint     ,
  omContSellingVolume     bigint     ,
  omPreCloseSellingVolume bigint     ,
  omSellingValue          float      ,
  ptBuyingVolume          bigint     ,
  ptBuyingValue           float      ,
  ptSellingVolume         bigint     ,
  ptSellingValue          float      ,
  report_date             date       ,
  last_update             date       ,
  CONSTRAINT PK_InfoB_ForeignTrading_stock PRIMARY KEY (ftID)
)
GO


CREATE SCHEMA InfoB_OrderPlacement
go

CREATE TABLE InfoB_OrderPlacement.stock
(
  opID             varchar(20) NOT NULL,
  ticker           varchar(10) NOT NULL,
  numBuyingOrders  bigint     ,
  buyingVolume     bigint     ,
  numSellingOrders bigint     ,
  sellingVolume    bigint     ,
  tradingVolume    bigint     ,
  netVolume        bigint     ,
  report_date      date       ,
  last_update      date       ,
  CONSTRAINT PK_InfoB_OrderPlacement PRIMARY KEY (opID)
)
GO


CREATE SCHEMA InfoB_Session
go

CREATE TABLE InfoB_Session.continuousopen
(
  tranID       varchar(20) NOT NULL,
  ticker       varchar(10) NOT NULL,
  highPrice    float      ,
  averagePrice float      ,
  lowPrice     float      ,
  omPrice      float      ,
  omVolume     bigint     ,
  omValue      float      ,
  report_date  date       ,
  last_update  date       
)
GO

CREATE TABLE InfoB_Session.preclose
(
  tranID               varchar(20) NOT NULL,
  ticker               varchar(10) NOT NULL,
  priorDayClose        float      ,
  closePrice           float      ,
  atcChangeStatus      varchar(10),
  atcChangePoint       float      ,
  atcChangePercent     float      ,
  atcTradingVolume     bigint     ,
  atcTradingValue      float      ,
  totalVolume          bigint     ,
  totalValue           float      ,
  listedShares         bigint     ,
  outstandingShares    bigint     ,
  adjOutstandingShares bigint     ,
  marketCap            bigint     ,
  report_date          date       ,
  last_update          date       
)
GO

CREATE TABLE InfoB_Session.preopen
(
  tranID           varchar(20) NOT NULL,
  ticker           varchar(10) NOT NULL,
  openPrice        float      ,
  atoChangeStatus  varchar(10),
  atoChangePoint   float      ,
  atoChangePercent float      ,
  atoVolume        bigint     ,
  atoValue         bigint     ,
  report_date      date       ,
  last_update      date       
)
GO

CREATE TABLE InfoB_Session.putthrough
(
  tranID          varchar(20) NOT NULL,
  ticker          varchar(10) NOT NULL,
  ptTradingVolume bigint     ,
  ptTradingValue  float      ,
  report_date     date       ,
  last_update     date       
)
GO

CREATE TABLE InfoB_Session.tranID
(
  tranID      varchar(20) NOT NULL,
  ticker      varchar(10) NOT NULL,
  report_date date       ,
  last_update date       ,
  CONSTRAINT PK_InfoB_Session_tranID PRIMARY KEY (tranID)
)
GO

CREATE TABLE orderflow
(
  ofID            varchar(100) NOT NULL,
  ticker          varchar(10)  NOT NULL,
  transation_time datetime    ,
  MQ			  int         ,
  MP              float       ,
  TQ              bigint      ,
  last_update     date        ,
  CONSTRAINT PK_orderflow PRIMARY KEY (ofID)
)
GO

-- ALTER TABLE InfoB_CommonStock.Sector
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_InfoB_CommonStock_Sector
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE InfoB_CommonStock.Category
--   ADD CONSTRAINT FK_InfoB_CommonStock_CategoryList_TO_InfoB_CommonStock_Category
--     FOREIGN KEY (GICS3)
--     REFERENCES InfoB_CommonStock.CategoryList (GICS3)
-- GO

-- ALTER TABLE InfoB_CommonStock.Category
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_InfoB_CommonStock_Category
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE InfoB_OrderPlacement.stock
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_InfoB_OrderPlacement_stock
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE InfoB_ForeignTrading.stock
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_InfoB_ForeignTrading_stock
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE InfoB_BasicIndicator.stock
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_InfoB_BasicIndicator_stock
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE fdata.EOD
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_fdata_EOD
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE freefloat
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_freefloat
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE orderflow
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_orderflow
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE InfoB_Session.preopen
--   ADD CONSTRAINT FK_InfoB_Session_tranID_TO_InfoB_Session_preopen
--     FOREIGN KEY (tranID)
--     REFERENCES InfoB_Session.tranID (tranID)
-- GO

-- ALTER TABLE InfoB_Session.putthrough
--   ADD CONSTRAINT FK_InfoB_Session_tranID_TO_InfoB_Session_putthrough
--     FOREIGN KEY (tranID)
--     REFERENCES InfoB_Session.tranID (tranID)
-- GO

-- ALTER TABLE InfoB_Session.tranID
--   ADD CONSTRAINT FK_InfoB_CommonStock_companyName_TO_InfoB_Session_tranID
--     FOREIGN KEY (ticker)
--     REFERENCES InfoB_CommonStock.companyName (ticker)
-- GO

-- ALTER TABLE InfoB_Session.preclose
--   ADD CONSTRAINT FK_InfoB_Session_tranID_TO_InfoB_Session_preclose
--     FOREIGN KEY (tranID)
--     REFERENCES InfoB_Session.tranID (tranID)
-- GO

-- ALTER TABLE InfoB_Session.continuousopen
--   ADD CONSTRAINT FK_InfoB_Session_tranID_TO_InfoB_Session_continuousopen
--     FOREIGN KEY (tranID)
--     REFERENCES InfoB_Session.tranID (tranID)
-- GO

