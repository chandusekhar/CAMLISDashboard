USE [LISDashboard]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter PROCEDURE [dbo].[VLLabSummary]
	@DateFrom nvarchar(100)='' ,
	@DateTo nvarchar(100)='',
	@CollectionFrom nvarchar(100)='' ,
	@CollectionTo nvarchar(100)='',
	@ProvincesId nvarchar(500)='',
	@FacilityType1 nvarchar(100)='',
	@LabCode nvarchar(100)='' 
AS
Begin

DECLARE  @VLFacility  TABLE(ProvinceName nvarchar(100),
							FacilityName nvarchar(100),
                            LaboratoryName nvarchar(500))
                            
                             
DECLARE @VLReport1 TABLE (   No_Patient int,
							No_Sample_Recieved int,
							No_Rejected_Sample int,							
							ProvinceName nvarchar(100),
							FacilityName nvarchar(100),
							LaboratoryName nvarchar(500)) 
							
DECLARE @VLReport2 TABLE (  No_of_Sample_Tested int,
							No_of_Sample_Not_Tested int,
							Tot_Detected_G_1000 int,
							Tot_Detected_LE_1000 int,
							Total_Suppressed int,
							Invalid_Error_Noresult int,
							ProvinceName nvarchar(100),
							FacilityName nvarchar(100),
							LaboratoryName nvarchar(500))     
							
DECLARE @VLReportAll TABLE (No_Outstanding int,							
							No_Patient int,
							No_Sample_Recieved int,
							No_Rejected_Sample int,
							No_of_Sample_Tested int,
							No_of_Sample_Not_Tested int,
							Tot_Detected_G_1000 int,
							Tot_Detected_LE_1000 int,
							Total_Suppressed int,
							Invalid_Error_Noresult int,
							ProvinceName nvarchar(100),
							FacilityName nvarchar(100),
							LaboratoryName nvarchar(500))     
                                                         
INSERT @VLFacility (ProvinceName,FacilityName,LaboratoryName)                                      
SELECT  Provinces.ProvinceName, Facilities.FacilityName as FacilityName,Laboratories.Description as LaboratoryName
FROM dbo.VLRequestSamples  vl LEFT OUTER JOIN 
Laboratories on vl.LabCode = Laboratories.LabCode LEFT OUTER JOIN 
dbo.Facilities ON dbo.Facilities.Id = vl.Facilityt_Id LEFT OUTER JOIN 
dbo.Provinces ON dbo.Facilities.ProvinceId = dbo.Provinces.Id 
Where 
(1 = Case when @DateFrom = '' and  @DateTo ='' Then 1 When vl.RecievedDate between @DateFrom and @DateTo Then 1 END
or 1 = Case when @DateFrom = '' and  @DateTo ='' Then 1 When vl.FinalReportDate between @DateFrom and @DateTo Then 1 END)
and 
(1 = Case when @CollectionFrom = '' and  @CollectionTo ='' Then 1 When vl.SampleCollectedDate between @CollectionFrom and @CollectionTo  Then 1 END
or 1 = Case when @CollectionFrom = '' and  @CollectionTo ='' Then 1 When vl.FinalReportDate between @CollectionFrom and @CollectionTo  Then 1 END)
and 1 = Case when @ProvincesId ='' Then 1 When charindex(',' + CAST(Provinces.Id as nvarchar(20)) + ',', @ProvincesId) > 0 Then 1 END 
and 1 = Case when @FacilityType1 ='' Then 1 When charindex(',' + CAST(Facilities.FacilityTypeId as nvarchar(20)) + ',', @FacilityType1) > 0  Then 1 END 
and 1 = Case when @LabCode ='' Then 1 When Laboratories.LabCode=@LabCode Then 1 END 
Group by Provinces.ProvinceName,Facilities.FacilityName,Laboratories.Description

--@VLReport1
INSERT @VLReport1 (No_Patient,No_Sample_Recieved,No_Rejected_Sample,ProvinceName,FacilityName,LaboratoryName)
SELECT   COUNT(Distinct dbo.VLPatients.ARTNumber),COUNT(dbo.VLRequestSamples.Id),COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Rejected' THEN 1 END),
Provinces.ProvinceName as ProvinceName_Ot,Facilities.FacilityName as FacilityName_Ot,Laboratories.Description as LaboratoryName
FROM dbo.VLPatients LEFT OUTER JOIN dbo.VLRequestSamples on VLPatients.Id=VLRequestSamples.VLPatient_Id LEFT OUTER JOIN
Laboratories on VLRequestSamples.LabCode = Laboratories.LabCode LEFT OUTER JOIN 
dbo.Facilities ON dbo.Facilities.Id = dbo.VLRequestSamples.Facilityt_Id  LEFT OUTER JOIN 
dbo.Provinces ON dbo.Facilities.ProvinceId = dbo.Provinces.Id 

Where    
1 = Case when @DateFrom = '' and  @DateTo ='' Then 1 When dbo.VLRequestSamples.RecievedDate between @DateFrom and @DateTo Then 1 END
and 1 = Case when @CollectionFrom = '' and  @CollectionTo ='' Then 1 When dbo.VLRequestSamples.SampleCollectedDate between @CollectionFrom and @CollectionTo Then 1 END
and 1 = Case when @ProvincesId ='' Then 1 When charindex(',' + CAST(Provinces.Id as nvarchar(20)) + ',', @ProvincesId) > 0 Then 1 END 
and 1 = Case when @FacilityType1 ='' Then 1 When charindex('' + CAST(Facilities.FacilityTypeId as nvarchar(20)) + ',', @FacilityType1) > 0  Then 1 END 
and 1 = Case when @LabCode ='' Then 1 When Laboratories.LabCode=@LabCode Then 1 END 
Group by Provinces.ProvinceName,Facilities.FacilityName,Laboratories.Description


--@VLReport2

 
INSERT @VLReport2 (No_of_Sample_Tested,No_of_Sample_Not_Tested,Tot_Detected_LE_1000,Tot_Detected_G_1000,Total_Suppressed,Invalid_Error_Noresult,
ProvinceName,FacilityName,LaboratoryName)
SELECT   COUNT(CASE WHEN VLRequestSamples.FinalReportResult != 'Rejected' and  VLRequestSamples.Status != 'RecivedFromFacility' THEN 1 END ),
COUNT(CASE WHEN VLRequestSamples.Status = 'RecivedFromFacility' THEN 1 END ),
(COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Detected' and  VLRequestSamples.Copies_ml <= 1000 THEN 1 END) 
+  COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Below Minimum Detectable Level'  THEN 1 END)
+  COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Not Detected'  THEN 1 END)),
( COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Detected' and  VLRequestSamples.Copies_ml > 1000 THEN 1 END) 
+  COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Above Upper Limit of Quantification'  THEN 1 END)),
COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Not Detected'  THEN 1 END),
(COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Invalid' THEN 1 END) +
  COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'Error' THEN 1 END) +
  COUNT(CASE WHEN VLRequestSamples.FinalReportResult = 'No Result' THEN 1 END)),
Provinces.ProvinceName as ProvinceName_Ot,Facilities.FacilityName as FacilityName_Ot,Laboratories.Description as LaboratoryName

FROM dbo.VLRequestSamples  LEFT OUTER JOIN 
Laboratories on VLRequestSamples.LabCode = Laboratories.LabCode LEFT OUTER JOIN 
dbo.Facilities ON dbo.Facilities.Id = dbo.VLRequestSamples.Facilityt_Id  LEFT OUTER JOIN 
dbo.Provinces ON dbo.Facilities.ProvinceId = dbo.Provinces.Id 

Where    
1 = Case when @DateFrom = '' and  @DateTo ='' Then 1 When dbo.VLRequestSamples.RecievedDate between @DateFrom and @DateTo Then 1 END
and 1 = Case when @CollectionFrom = '' and  @CollectionTo ='' Then 1 When dbo.VLRequestSamples.SampleCollectedDate between @CollectionFrom and @CollectionTo Then 1 END
and 1 = Case when @ProvincesId ='' Then 1 When charindex(',' + CAST(Provinces.Id as nvarchar(20)) + ',', @ProvincesId) > 0 Then 1 END 
and 1 = Case when @FacilityType1 ='' Then 1 When charindex(',' + CAST(Facilities.FacilityTypeId as nvarchar(20)) + ',', @FacilityType1) > 0  Then 1 END 
and 1 = Case when @LabCode ='' Then 1 When Laboratories.LabCode=@LabCode Then 1 END 
Group by Provinces.ProvinceName,Facilities.FacilityName,Laboratories.Description

INSERT  @VLReportAll (ProvinceName,FacilityName,LaboratoryName)                                      
SELECT  ProvinceName,FacilityName, LaboratoryName FROM @VLFacility

DECLARE @MyCursor CURSOR;
DECLARE	@ProvinceName nvarchar(100) = '';
DECLARE	@FacilityName nvarchar(100) = '';
DECLARE	@LaboratoryName nvarchar(500) = '';

BEGIN
SET @MyCursor = CURSOR FOR
    select ProvinceName,FacilityName,LaboratoryName from @VLFacility     

    OPEN @MyCursor 
    FETCH NEXT FROM @MyCursor 
    INTO @ProvinceName,@FacilityName,@LaboratoryName

    WHILE @@FETCH_STATUS = 0
    BEGIN    
    
	 
	 --VLReport1
     Update A set No_Patient=ISNULL(OT.No_Patient, 0 ),
     No_Sample_Recieved=ISNULL(OT.No_Sample_Recieved, 0 ),
     No_Rejected_Sample=ISNULL(OT.No_Rejected_Sample, 0 )     
     from @VLReportAll A LEFT OUTER JOIN @VLReport1 OT on A.ProvinceName = ot.ProvinceName and 
	 A.FacilityName = ot.FacilityName and A.LaboratoryName = ot.LaboratoryName
	  where A.ProvinceName=@ProvinceName and A.FacilityName=@FacilityName and A.LaboratoryName=@LaboratoryName;

	--VLReport2
	 Update A set No_of_Sample_Tested=ISNULL(OT.No_of_Sample_Tested, 0 ),
	 No_of_Sample_Not_Tested=ISNULL(OT.No_of_Sample_Not_Tested, 0 ),
     Tot_Detected_G_1000=ISNULL(OT.Tot_Detected_G_1000, 0 ),
     Tot_Detected_LE_1000=ISNULL(OT.Tot_Detected_LE_1000, 0 ),
     Total_Suppressed=ISNULL(OT.Total_Suppressed, 0 ),
     Invalid_Error_Noresult=ISNULL(OT.Invalid_Error_Noresult, 0 )
     from @VLReportAll A LEFT OUTER JOIN @VLReport2 OT on A.ProvinceName = ot.ProvinceName and 
	 A.FacilityName = ot.FacilityName and A.LaboratoryName = ot.LaboratoryName
	 where A.ProvinceName=@ProvinceName and A.FacilityName=@FacilityName and A.LaboratoryName=@LaboratoryName;
	 
	  Update @VLReportAll set 
	  No_of_Sample_Not_Tested=((No_Outstanding+No_Sample_Recieved)- (No_of_Sample_Tested+No_Rejected_Sample))
  
	 
	  FETCH NEXT FROM @MyCursor 
    INTO @ProvinceName,@FacilityName,@LaboratoryName
    END
   
    CLOSE @MyCursor ;
    DEALLOCATE @MyCursor;
END
--INSERT @VLReportAll
--(No_Patient_Ot,No_Sample_Recieved_Ot,No_Rejected_Sample_Ot,No_of_Sample_Tested_Ot,No_of_Sample_Not_Tested_Ot,
--Tot_Detected_G_1000_Ot,Tot_Detected_LE_1000_Ot,Total_Suppressed_Ot,Invalid_Error_Noresult_Ot,
--No_Patient,No_Sample_Recieved,No_Rejected_Sample,No_of_Sample_Tested,No_of_Sample_Not_Tested,
--Tot_Detected_G_1000,Tot_Detected_LE_1000,Total_Suppressed,Invalid_Error_Noresult,ProvinceName,FacilityName,LaboratoryName)
--select OT.No_Patient_Ot,OT.No_Sample_Recieved_Ot,OT.No_Rejected_Sample_Ot,OT.No_of_Sample_Tested_Ot,OT.No_of_Sample_Not_Tested_Ot,
--OT.Tot_Detected_G_1000_Ot,OT.Tot_Detected_LE_1000_Ot,OT.Total_Suppressed_Ot,OT.Invalid_Error_Noresult_Ot,
--No_Patient,No_Sample_Recieved,No_Rejected_Sample,No_of_Sample_Tested,No_of_Sample_Not_Tested,
--Tot_Detected_G_1000,Tot_Detected_LE_1000,Total_Suppressed,Invalid_Error_Noresult,
--OT.ProvinceName,OT.FacilityName,OT.LaboratoryName
--from @VLFacility  f LEFT OUTER JOIN @VLOTReport OT on f.ProvinceName = ot.ProvinceName and 
--f.FacilityName = ot.FacilityName LEFT OUTER JOIN @VLReport r on f.ProvinceName = r. ProvinceName and 
--f.FacilityName = r. FacilityName

select * from @VLReportAll
--select * from @VLFacility
end