
USE			EpicorERP

-- ---------------------------------------------------------------------------------------------------------
-- <GEN DATE>08/11/2015 14:26:00</GEN DATE>
-- <MODIFIED>Yes</MODIFIED> 
/* <FIX DESCRIPTION> */
/* This fix program compares the data on the partbin table with the data on the partfifocost table  */
/* for a given part and tries to reconcile the entries.  Where there are inconsistencies, it  */
/* updates the partfifocost layers to match what is found in the partbin table. */
/* </FIX DESCRIPTION> */
-- ---------------------------------------------------------------------------------------------------------
set nocount on
DECLARE @sql nvarchar(max), @sysrowid nvarchar(50) = ''

DECLARE
	  @Company nvarchar(1000) = '<ALL>'
	, @PartNum nvarchar(1000) = ''    --<------------ you must enter the part number that you want to run this for
	, @updind bit = 1								-- 0 - display only,  1 - display and update

DECLARE @companyP_company nvarchar(8), @companyP_sysrow uniqueidentifier, @xasyst_plantcostid nvarchar(8)
DECLARE @part_company nvarchar(8), @part_partnum nvarchar(50), @part_sysrow uniqueidentifier,
	@uomclass_BaseUOMCode nvarchar(10), @part_ium nvarchar(10)
DECLARE @partfifocost_company nvarchar(8), @partfifocost_costid nvarchar(8), @partfifocost_fifodate 
date, @partfifocost_fifoseq int, @partfifocost_fifosubseq int, @partfifocost_lotnum nvarchar(30), 
@partfifocost_onhandqty decimal(22,8), @partfifocost_partnum nvarchar(50), 
@partfifocost_onhandqtynew decimal(22,8), @partfifocost_sysrow uniqueidentifier,
@partfifocost_sysrowid uniqueidentifier, @partlot_sysrow uniqueidentifier,
@negbinqty decimal(22,8), @negbinqty_ind nvarchar(10), @rowid int, @arowid int

declare @partplant_Plant nvarchar(8), @plantcost_PlantCostID nvarchar(8), @partplant_costmethod nvarchar(8),
	@partbin_lotnum nvarchar(30), @partbin_onhandqty decimal(22,8), @lnumofdec int,
	@partbin_dimcode nvarchar(10), @partplant_sysrow uniqueidentifier,
	@vonhandqty decimal(22,8), @bcrowid int, @nonhandqty decimal(20,8), @lgood bit,
	@partfifotransysrowid uniqueidentifier, @partfifocost_origonhandqty decimal(22,8)

if exists (select name from tempdb.sys.tables where name like '%#bincost%')
	drop table #bincost

create table  #bincost (
	company nvarchar(8),
	partnum nvarchar(50),
	lotnum nvarchar(30),
	costid nvarchar(8),
	costmethod nvarchar(8),
	onhandqty decimal(20,8),
	origonhandqty decimal(20,8),
	negbinqty decimal(20,8) ,
	donotuse int,
	partfifocostsysrowid uniqueidentifier null ,
	partplantsysrowid uniqueidentifier null,
	rowid int identity(1,1),
	)
create nonclustered index ix1 on #bincost(rowid) 
create nonclustered index ix2 on #bincost(company,partnum,lotnum,costid,onhandqty) 
create nonclustered index ix3 on #bincost(partfifocostsysrowid) 
create nonclustered index ix4 on #bincost(negbinqty) 
create nonclustered index ix5 on #bincost(donotuse) 


declare @updinfo as table(
	company nvarchar(8),
	partnum nvarchar(50),
	costid nvarchar(8),
	lotnum nvarchar(30),
	costmethod nvarchar(8),
	onhandqty decimal(20,8),
	partfifocostsysrowid uniqueidentifier null,
	fifoseq int,
	origonhandqty decimal(20,8),
	negbinqty_ind nvarchar(10),
	negbinqty decimal(22,8),
	partplantsysrowid uniqueidentifier null,
	partfifotransysrowid uniqueidentifier null,
	origorigonhandqty decimal(20,8)
	)

DECLARE companyP_cursor cursor for
select companyP.company, companyP.sysrowid, isnull(xasyst.plantcostid,'')
 from Erp.company companyP
 join Erp.XaSyst xasyst on XASyst.Company = companyp.Company 
 where (companyP.company = @Company or @Company = '<ALL>')
order by companyP.company
OPEN companyP_cursor
FETCH NEXT FROM companyP_cursor into @companyP_company, @companyP_sysrow,@xasyst_plantcostid
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE part_cursor cursor for
    select part.company, part.partnum, part.sysrowid, uomclass.BaseUOMCode, part.ium 
     from Erp.part part
	 join Erp.UOMClass uomclass on uomclass.Company = part.Company and uomclass.UOMClassID = part.UOMClassID
     where part.company = @companyP_company and (part.partnum = @PartNum )
    OPEN part_cursor
    FETCH NEXT FROM part_cursor into @part_company, @part_partnum, @part_sysrow, @uomclass_BaseUOMCode,@part_ium
    WHILE @@FETCH_STATUS = 0
    BEGIN
		delete from #bincost
		
	    DECLARE partplant_cursor cursor for
		select partplant.Plant, plantcost.PlantCostID, case when partplant.CostMethod = '' then part.costmethod else partplant.costmethod end, partplant.sysrowid
		from Erp.plant plant
		join Erp.plantcost plantcost on PlantCost.Company = plant.company 
			and plantcost.plantcostid = case when isnull(plant.plantcostid,'') = '' then  isnull(@xasyst_plantcostid,'') else  isnull(plant.plantcostid,'') end
			and plantcost.PlantCostID <> ''
		join Erp.PartPlant partplant on partplant.company = plant.Company and partplant.plant = plant.plant 
			and partplant.PartNum = @part_partnum
		join erp.part on part.sysrowid = @part_sysrow
		where plant.company = @companyp_company
		and 
		(case when partplant.CostMethod = '' then part.costmethod else partplant.costmethod end in ('O','F')
		 OR PlantCost.EnableFIFOLayers = 1)
		OPEN partplant_cursor
		FETCH NEXT FROM partplant_cursor into @partplant_plant, @plantcost_plantcostid, @partplant_costmethod, @partplant_sysrow
		WHILE @@FETCH_STATUS = 0
		BEGIN
		    DECLARE PartBin_cursor cursor for
			select case when @partplant_costmethod = 'O' then partbin.lotnum else '' end,
				partbin.OnhandQty, partbin.dimcode
			from Erp.Warehse warehse
			join Erp.PartBin partbin on partbin.company = warehse.company and partbin.partnum = @part_partnum
				and partbin.WarehouseCode = warehse.WarehouseCode and partbin.onhandqty <> 0
			where warehse.company = @part_company and warehse.plant = @partplant_plant
			OPEN PartBin_cursor
			FETCH NEXT FROM PartBin_cursor into @partbin_lotnum, @partbin_onhandqty, @partbin_dimcode
			WHILE @@FETCH_STATUS = 0
			BEGIN
				set @vonhandqty = @partbin_onhandqty

				IF isnull(@part_ium,'') <> '' 
				begin
				    /*if part bin uom is not the base inventory uom then we need to convert partbin.dimcode to part.ium*/
					if @part_ium <> @partbin_dimcode
					begin
						if @partbin_dimcode <> @uomclass_baseuomcode 
						begin
							select @vonhandqty = case when partuom.convoperator = '*'
								then @partbin_onhandqty * partuom.convfactor
								else @partbin_onhandqty / partuom.convfactor end 
							from erp.partuom partuom 
							where PartUOM.Company = @companyp_Company
                                 AND PartUOM.PartNum = @part_partnum
                                 AND PartUOM.UOMCode = @partbin_dimcode
                                 AND PartUOM.Active = 1
                                 AND PartUOM.ConvFactor <> 0

							if @@rowcount = 0
							begin 
								select @vonhandqty = case when uomconv.convoperator = '*'
									then @partbin_onhandqty * uomconv.convfactor
									else @partbin_onhandqty / uomconv.convfactor end
								from erp.UOMConv uomconv
								WHERE UOMConv.Company = @companyP_company
                                     AND UOMConv.UOMCode = @partbin_dimcode
									 and uomconv.Active = 1
                                     AND UOMConv.ConvFactor <> 0
							end 
						end

						if @uomclass_BaseUOMCode <> @part_ium 
						begin
							select @vonhandqty = case when partuom.convoperator = '*'
								then @vonhandqty / partuom.convfactor
								else @vonhandqty * partuom.convfactor end 
							from erp.partuom partuom 
							where PartUOM.Company = @companyp_Company
                                 AND PartUOM.PartNum = @part_partnum
                                 AND PartUOM.UOMCode = @part_ium
                                 AND PartUOM.Active = 1
                                 AND PartUOM.ConvFactor <> 0

							if @@rowcount = 0
							begin 
								select @vonhandqty = case when uomconv.convoperator = '*'
									then @vonhandqty / uomconv.convfactor
									else @vonhandqty * uomconv.convfactor end
								from erp.UOMConv uomconv
								WHERE UOMConv.Company = @companyP_company
                                     AND UOMConv.UOMCode = @part_ium
									 and uomconv.Active = 1
                                     AND UOMConv.ConvFactor <> 0
							end 
						end 
					end

					if @vonhandqty <> 0
					begin
						select @lnumofdec = isnull((select numofdec from Erp.uom uom
							where uom.company = @companyp_company and uom.uomcode = @part_ium
							and uom.active = 1), null)
						if @lnumofdec is not null
						begin
							while round(@vonhandqty,@lnumofdec) = 0
							begin
								set @lnumofdec = @lnumofdec + 1
							end 
							set @vonhandqty = round(@vonhandqty,@lnumofdec) 
						end 

					end 
				end 

				select @negbinqty = @vonhandqty
				while @vonhandqty <> 0
				begin
					select @bcrowid = isnull((select top 1 rowid from #bincost b where b.company = @companyP_company
						and b.partnum = @part_partnum and b.lotnum = @partbin_lotnum
						and b.costid = @plantcost_plantcostid and b.onhandqty < b.origonhandqty), null)
					if @bcrowid is null
					begin
						insert #bincost(company,partnum,lotnum,costid,costmethod,onhandqty,origonhandqty,partfifocostsysrowid, negbinqty, partplantsysrowid, donotuse)
						select top 1 p.company, p.partnum, p.lotnum, p.costid, @partplant_costmethod, 0, 
							case when isnull(o.origonhandqty,p.origonhandqty) = 0 then isnull(o.onhandqty,p.onhandqty) + isnull(o.consumedqty,p.consumedqty) else isnull(o.origonhandqty,p.origonhandqty) end, p.sysrowid, 0, @partplant_sysrow, 0
						from erp.partfifocost p
						left outer join erp.partfifocost o on o.company = p.company and o.partnum = p.partnum and o.lotnum = p.lotnum and o.costid = p.costid
							and o.fifodate = p.fifodate and o.fifoseq = p.fifoseq and o.fifosubseq = 0
						left outer join #bincost b on b.partfifocostsysrowid = p.SysRowID
						join (select company, partnum, lotnum, costid, fifodate, fifoseq, max(fifosubseq)
							from erp.partfifocost 
							group by company, partnum, lotnum, costid, fifodate, fifoseq)
							as m(company, partnum, lotnum, costid, fifodate, fifoseq,fifosubseq)
							on m.company = p.company and m.partnum = p.partnum and m.lotnum = p.lotnum and m.fifodate = p.fifodate and m.fifoseq = p.fifoseq and m.fifosubseq = p.fifosubseq
						where p.company = @companyP_company and p.PartNum = @part_partnum and p.lotnum = @partbin_lotnum
							and p.costid = @plantcost_PlantCostID and p.InActive = 0 
							and b.partfifocostsysrowid is null
						order by p.FIFODate desc, p.FIFOSeq desc, p.FIFOSubSeq desc

						if @@rowcount = 0
						begin
							insert #bincost(company,partnum,lotnum,costid,costmethod,onhandqty,origonhandqty,partfifocostsysrowid, negbinqty, partplantsysrowid, donotuse)
							select top 1 p.company, p.partnum, p.lotnum, p.costid, @partplant_costmethod, 0, 
								case when isnull(o.origonhandqty,p.origonhandqty) = 0 then isnull(o.onhandqty,p.onhandqty) + isnull(o.consumedqty,p.consumedqty) else isnull(o.origonhandqty,p.origonhandqty) end, p.sysrowid, 0, @partplant_sysrow,0
							from erp.partfifocost p
							left outer join erp.partfifocost o on o.company = p.company and o.partnum = p.partnum and o.lotnum = p.lotnum and o.costid = p.costid
								and o.fifodate = p.fifodate and o.fifoseq = p.fifoseq and o.fifosubseq = 0
							left outer join #bincost b on b.partfifocostsysrowid = p.SysRowID
							join (select company, partnum, lotnum, costid, fifodate, fifoseq, max(fifosubseq)
								from erp.partfifocost 
								group by company, partnum, lotnum, costid, fifodate, fifoseq)
								as m(company, partnum, lotnum, costid, fifodate, fifoseq,fifosubseq)
								on m.company = p.company and m.partnum = p.partnum and m.lotnum = p.lotnum and m.fifodate = p.fifodate and m.fifoseq = p.fifoseq and m.fifosubseq = p.fifosubseq
							where p.company = @companyP_company and p.PartNum = @part_partnum and p.lotnum = @partbin_lotnum
								and p.costid = @plantcost_PlantCostID
								and b.partfifocostsysrowid is null
							order by p.FIFODate desc, p.FIFOSeq desc, p.FIFOSubSeq desc

							if @@rowcount = 0
							begin
								insert #bincost(company,partnum,lotnum,costid,costmethod,onhandqty,origonhandqty,partfifocostsysrowid, negbinqty, partplantsysrowid,donotuse)
								select top 1 @companyP_company, @part_partnum, @partbin_lotnum, @plantcost_PlantCostID, @partplant_costmethod, 0, 
									0, null, 0, @partplant_sysrow, 0
							end
						end 
						select @bcrowid = isnull((select top 1 rowid from #bincost b where b.company = @companyP_company
							and b.partnum = @part_partnum and b.lotnum = @partbin_lotnum
							and b.costid = @plantcost_plantcostid and (b.onhandqty < b.origonhandqty or b.origonhandqty = 0)), null)
						if @bcrowid is null break
					end

					if exists (select 1 from #bincost where @vonhandqty > (origonhandqty - onhandqty) and origonhandqty <> 0 and rowid = @bcrowid)
						select @nonhandqty = origonhandqty,
							@vonhandqty = @vonhandqty - (origonhandqty  - onhandqty) 
							from #bincost where rowid = @bcrowid
					else
						select @nonhandqty = case when onhandqty + @vonhandqty < 0 then 0 else onhandqty + @vonhandqty end,
							@vonhandqty = 0
							from #bincost where rowid = @bcrowid

					update b 
					set onhandqty = @nonhandqty ,
					negbinqty = case when @negbinqty < 0 then @negbinqty else negbinqty end
					from #bincost b where rowid = @bcrowid
				end

				if @vonhandqty < 0
				begin
					insert #bincost(company,partnum,lotnum,costid,costmethod,onhandqty,origonhandqty,partfifocostsysrowid, negbinqty,partplantsysrowid, donotuse)
					select top 1 p.company, p.partnum, p.lotnum, p.costid, @partplant_costmethod, 0, 
						case when isnull(o.origonhandqty,p.origonhandqty) = 0 then isnull(o.onhandqty,p.onhandqty) + isnull(o.consumedqty,p.consumedqty) else isnull(o.origonhandqty,p.origonhandqty) end, p.sysrowid,
						 @vonhandqty, @partplant_sysrow, 0
					from erp.partfifocost p
					left outer join erp.partfifocost o on o.company = p.company and o.partnum = p.partnum and o.lotnum = p.lotnum and o.costid = p.costid
						and o.fifodate = p.fifodate and o.fifoseq = p.fifoseq and o.fifosubseq = 0
					left outer join #bincost b on b.partfifocostsysrowid = p.SysRowID
					join (select company, partnum, lotnum, costid, fifodate, fifoseq, max(fifosubseq)
						from erp.partfifocost 
						group by company, partnum, lotnum, costid, fifodate, fifoseq)
						as m(company, partnum, lotnum, costid, fifodate, fifoseq,fifosubseq)
						on m.company = p.company and m.partnum = p.partnum and m.lotnum = p.lotnum and m.fifodate = p.fifodate and m.fifoseq = p.fifoseq and m.fifosubseq = p.fifosubseq
					where p.company = @companyP_company and p.PartNum = @part_partnum and p.lotnum = @partbin_lotnum
						and p.costid = @plantcost_PlantCostID and p.InActive = 0 
						and b.partfifocostsysrowid is null
					order by p.FIFODate desc, p.FIFOSeq desc, p.FIFOSubSeq desc
				end


				insert #bincost(company,partnum,lotnum,costid,costmethod,onhandqty,origonhandqty,partfifocostsysrowid, negbinqty, partplantsysrowid, donotuse)
				select p.company, p.partnum, p.lotnum, p.costid, @partplant_costmethod, 0, isnull(o.origonhandqty,p.OrigOnHandQty), p.sysrowid, 0, @partplant_sysrow, 0
				from erp.partfifocost p
				left outer join erp.partfifocost o on o.company = p.company and o.partnum = p.partnum and o.lotnum = p.lotnum and o.costid = p.costid
					and o.fifodate = p.fifodate and o.fifoseq = p.fifoseq and o.fifosubseq = 0
				left outer join #bincost b on b.partfifocostsysrowid = p.SysRowID
				join (select company, partnum, lotnum, costid, fifodate, fifoseq, max(fifosubseq)
					from erp.partfifocost 
					group by company, partnum, lotnum, costid, fifodate, fifoseq)
					as m(company, partnum, lotnum, costid, fifodate, fifoseq,fifosubseq)
					on m.company = p.company and m.partnum = p.partnum and m.lotnum = p.lotnum and m.fifodate = p.fifodate and m.fifoseq = p.fifoseq and m.fifosubseq = p.fifosubseq
				where p.company = @companyP_company and p.PartNum = @part_partnum
					and p.costid = @plantcost_PlantCostID 
					and b.partfifocostsysrowid is null
					order by p.FIFODate desc, p.FIFOSeq desc, p.FIFOSubSeq desc

				FETCH NEXT FROM PartBin_cursor into @partbin_lotnum, @partbin_onhandqty, @partbin_dimcode
			end
			CLOSE partbin_cursor;
			DEALLOCATE partbin_cursor;

			FETCH NEXT FROM partplant_cursor into @partplant_plant, @plantcost_plantcostid, @partplant_costmethod, @partplant_sysrow
		end 
		close partplant_cursor;
		deallocate partplant_cursor;

		insert #bincost(company,partnum,lotnum,costid,costmethod,onhandqty,origonhandqty,partfifocostsysrowid, partplantsysrowid, donotuse) 
		select p.company, p.partnum, p.lotnum, p.costid, '', 0, isnull(o.origonhandqty,p.OrigOnHandQty), p.sysrowid, null, case when m.fifosubseq = p.fifosubseq then 0 else 1 end
		from erp.partfifocost p
		left outer join erp.partfifocost o on o.company = p.company and o.partnum = p.partnum and o.lotnum = p.lotnum and o.costid = p.costid
			and o.fifodate = p.fifodate and o.fifoseq = p.fifoseq and o.fifosubseq = 0
		left outer join #bincost b on b.partfifocostsysrowid = p.SysRowID
		join (select company, partnum, lotnum, costid, fifodate, fifoseq, max(fifosubseq)
			from erp.partfifocost 
			group by company, partnum, lotnum, costid, fifodate, fifoseq)
			as m(company, partnum, lotnum, costid, fifodate, fifoseq,fifosubseq)
			on m.company = p.company and m.partnum = p.partnum and m.lotnum = p.lotnum and m.fifodate = p.fifodate and m.fifoseq = p.fifoseq
		where p.company = @companyP_company and p.PartNum = @part_partnum
			and b.partfifocostsysrowid is null
		order by p.FIFODate desc, p.FIFOSeq desc, p.FIFOSubSeq desc


		declare @neg_lotnum nvarchar(1000)
		DECLARE negbinqty_cursor cursor for
		select case when costmethod = 'O' then lotnum else '' end, sum(negbinqty)  from #bincost 
		where negbinqty < 0
		group by case when costmethod = 'O' then lotnum else '' end
		OPEN negbinqty_cursor
		FETCH NEXT FROM negbinqty_cursor into @neg_lotnum, @negbinqty
		while @@FETCH_STATUS = 0
		begin
			DECLARE bincost_cursor cursor for
			select b.rowid, b.onhandqty from #bincost b
			join erp.partfifocost c on c.sysrowid = b.partfifocostsysrowid 
			where (b.costmethod <> 'O' or b.lotnum = @neg_lotnum) and  b.donotuse = 0
			order by c.FIFODate , c.FIFOSeq , c.FIFOSubSeq 

			OPEN bincost_cursor
			FETCH NEXT FROM bincost_cursor into @rowid, @partfifocost_onhandqty
			WHILE @negbinqty < 0 
			BEGIN
				if @partfifocost_onhandqty + @negbinqty >= 0
				begin
					update #bincost
					set onhandqty = onhandqty + @negbinqty
					where rowid = @rowid
					set @negbinqty = 0
				end
				else
				begin
					update #bincost
					set onhandqty = 0
					where rowid = @rowid
					set @negbinqty = @negbinqty + @partfifocost_onhandqty
				end
				FETCH NEXT FROM bincost_cursor into @arowid, @partfifocost_onhandqty
				if @@FETCH_STATUS <> 0
				begin
					update #bincost
					set onhandqty = onhandqty + @negbinqty
					where rowid = @rowid
					break
				end
				else
					set @rowid = @arowid
			end
			close bincost_cursor;
			deallocate bincost_cursor;

			FETCH NEXT FROM negbinqty_cursor into @neg_lotnum, @negbinqty
		end
		close negbinqty_cursor;
		deallocate 	negbinqty_cursor;

		DECLARE bincost_cursor cursor for
		select bincost.lotnum, bincost.costid, bincost.onhandqty, isnull(p.onhandqty,0), 
			isnull(partfifocostsysrowid, @part_sysrow), isnull(p.fifoseq,0), p.SysRowID ,
			bincost.costmethod , 0, t.sysrowid, bincost.origonhandqty
		from #bincost bincost
		left outer join erp.partfifocost p on p.sysrowid = partfifocostsysrowid 
		left outer join erp.partfifocost o on o.company = p.company and o.partnum = p.partnum and o.lotnum = p.lotnum and o.costid = p.costid
			and o.fifodate = p.fifodate and o.fifoseq = p.fifoseq and o.fifosubseq = 0
		left outer join (select company,partnum, lotnum, costid, fifodate,fifoseq,fifosubseq,min(convert(varchar(100),trannum) + ' ' + convert(varchar(100),sysrowid))
		from erp.partfifotran 
		group by company,partnum, lotnum, costid, fifodate,fifoseq,fifosubseq) as m(company,partnum, lotnum, costid, fifodate,fifoseq,fifosubseq,trannum_sysrowid)
		on m.company = p.company and m.partnum = p.partnum and m.lotnum = p.lotnum and m.costid = p.costid and m.fifodate = p.fifodate and m.fifoseq = p.fifoseq
		and m.fifosubseq = p.fifosubseq
		left outer join erp.partfifotran t on t.sysrowid = case when m.trannum_sysrowid is null then null else substring(m.trannum_sysrowid,charindex(' ', trannum_sysrowid) + 1,1000) end
		where (p.sysrowid is null and bincost.onhandqty  <> 0) or (isnull(p.onhandqty,0) <> bincost.onhandqty 
		 or (isnull(p.onhandqty,-1) = 0 AND isnull(isnull(o.origonhandqty,p.origonhandqty),-1) = 0)
		 or (bincost.donotuse = 1 and isnull(p.inactive,1) = 0)
		 or (bincost.donotuse = 0 and bincost.onhandqty <> 0 and not (
			isnull(p.fifomaterialcost,0) = isnull(t.mtlunitcost,isnull(p.fifomaterialcost,0)) and
			isnull(p.fifolaborcost,0) = isnull(t.lbrunitcost,isnull(p.fifolaborcost,0)) and
			isnull(p.fifoburdencost,0) = isnull(t.burunitcost,isnull(p.fifoburdencost,0)) and
			isnull(p.fifosubcontcost,0) = isnull(t.subunitcost,isnull(p.fifosubcontcost,0)) and
			isnull(p.fifomtlburcost,0) = isnull(t.mtlburunitcost,isnull(p.fifomtlburcost,0)) and
			p.OrigOnHandQty = bincost.origonhandqty)))
		OPEN bincost_cursor
		FETCH NEXT FROM bincost_cursor into @partfifocost_lotnum, @partfifocost_costid, @partfifocost_onhandqtynew,
			@partfifocost_onhandqty, @partfifocost_sysrow, @partfifocost_fifoseq, @partfifocost_sysrowid,
			@partplant_costmethod, @negbinqty, @partfifotransysrowid, @partfifocost_origonhandqty
		WHILE @@FETCH_STATUS = 0
		BEGIN
		   select @negbinqty_ind = case when @negbinqty < 0 then '** YES **' else '' end
			insert @updinfo 
			select @companyP_company, @part_partnum, @partfifocost_costid, @partfifocost_lotnum,
				@partplant_costmethod, @partfifocost_onhandqtynew, @partfifocost_sysrowid,
				@partfifocost_fifoseq, @partfifocost_onhandqty, @negbinqty_ind, @negbinqty, @partplant_sysrow, @partfifotransysrowid, @partfifocost_origonhandqty

			FETCH NEXT FROM bincost_cursor into @partfifocost_lotnum, @partfifocost_costid, @partfifocost_onhandqtynew,
				@partfifocost_onhandqty, @partfifocost_sysrow, @partfifocost_fifoseq, @partfifocost_sysrowid,
				@partplant_costmethod, @negbinqty, @partfifotransysrowid, @partfifocost_origonhandqty
        END
		close bincost_cursor;
		deallocate bincost_cursor;
        FETCH NEXT FROM part_cursor into @part_company, @part_partnum, @part_sysrow, @uomclass_BaseUOMCode, @part_ium
    END
    CLOSE part_cursor;
    DEALLOCATE part_cursor;
    
FETCH NEXT FROM companyP_cursor into @companyP_company, @companyP_sysrow,@xasyst_plantcostid
END
CLOSE companyP_cursor;
DEALLOCATE companyP_cursor;

select u.onhandqty + negbinqty newonhandqty, c.*, u.partfifotransysrowid from @updinfo u
join erp.partfifocost c on c.sysrowid = u.partfifocostsysrowid
order by c.company,c.partnum,c.lotnum,c.costid,c.fifodate,c.fifoseq,c.fifosubseq


if @updind = 1
begin
	DECLARE updinfo_cursor cursor for
	select company, partnum, costid, lotnum, costmethod, partfifocostsysrowid, onhandqty + negbinqty, partplantsysrowid, partfifotransysrowid, origorigonhandqty
	from @updinfo

	OPEN updinfo_cursor
	FETCH NEXT FROM updinfo_cursor into @partfifocost_company, @partfifocost_partnum, @partfifocost_costid,
		@partfifocost_lotnum, @partplant_costmethod, @partfifocost_sysrowid, @partfifocost_onhandqtynew, @partplant_sysrow, @partfifotransysrowid, @partfifocost_origonhandqty
	WHILE @@FETCH_STATUS = 0
	BEGIN
		begin tran -- ds generated

		update erp.partplant
		set costmethod = @partplant_costmethod
		where sysrowid = @partplant_sysrow and costmethod = ''

		if @partfifocost_sysrowid is null
		begin
			set @partfifocost_sysrowid = newid()
			insert ERP.PartFIFOCost (company, partnum, lotnum, costid, fifodate, fifosubseq, OnHandQty,sysdate, SysTime,
			sourcetype,SourceSysDate,SourceSysTime,SourceTranNum,OrigOnHandQty,LastRefDate,SourceKey1, fifoseq, sysrowid)
			select @partfifocost_company, @partfifocost_partnum, @partfifocost_lotnum, @partfifocost_costid,
			getdate(), 0, @partfifocost_onhandqtynew, getdate(),
			SUBSTRING(CAST(GETDATE() AS binary(8)),4,8)/300 , 'ADJ-QTY', getdate(), 
			SUBSTRING(CAST(GETDATE() AS binary(8)),4,8)/300 , 0, 0, getdate(), 'ADJ-QTY',
			isnull((select max(fifoseq) from erp.partfifocost bpartfifocost where bpartfifocost.company = @partfifocost_company AND 
					bpartfifocost.partnum = @partfifocost_partnum AND 
					bpartfifocost.lotnum = @partfifocost_lotnum AND 
					bpartfifocost.costid = @partfifocost_costid AND 
					bpartfifocost.fifodate = cast(getdate() as date)),0) + 1 , @partfifocost_sysrowid
			
			if @@rowcount > 0
			begin
		if exists (select 1 from sys.tables where name = 'partfifocost_UD')
			INSERT Erp.partfifocost_UD ( foreignsysrowid ) 
			select @partfifocost_sysrowid

				if @partplant_costmethod = 'O'
				begin
					select @partlot_sysrow = isnull((select top 1 partlot.sysrowid
					from erp.partlot partlot where partlot.Company = @partfifocost_Company AND partlot.PartNum = @partfifocost_PartNum 
						AND ltrim(rtrim(partlot.LotNum)) = @partfifocost_LotNum ),null)

					if @partlot_sysrow is not null
						update Erp.partfifocost 
						set PartFIFOCost.FIFOLaborCost = PartLot.FIFOLotLaborCost,
										PartFIFOCost.FIFOBurdenCost = PartLot.FIFOLotBurdenCost,
										PartFIFOCost.FIFOMaterialCost = PartLot.FIFOLotMaterialCost,
										PartFIFOCost.FIFOSubContCost = PartLot.FIFOLotSubContCost,
										PartFIFOCost.FIFOMtlBurCost = PartLot.FIFOLotMtlBurCost
						from erp.partfifocost partfifocost
						join erp.partlot partlot on partLot.sysrowid = @partlot_sysrow
						where partfifocost.sysrowid = @partfifocost_sysrowid
				end
				else
				begin
					select @partlot_sysrow = isnull((select top 1 partcost.sysrowid
					from erp.partcost partcost where partcost.Company = @partfifocost_Company AND partcost.PartNum = @partfifocost_PartNum 
						and partcost.CostID = @partfifocost_costid ),null)

					if @partlot_sysrow is not null
						update Erp.partfifocost 
						set PartFIFOCost.FIFOLaborCost = PartCost.AvgLaborCost,
										PartFIFOCost.FIFOBurdenCost = PartCost.AvgBurdenCost,
										PartFIFOCost.FIFOMaterialCost = PartCost.AvgMaterialCost,
										PartFIFOCost.FIFOSubContCost = PartCost.AvgSubContCost,
										PartFIFOCost.FIFOMtlBurCost = PartCost.AvgMtlBurCost
						from erp.partfifocost partfifocost
						join erp.partcost partcost on partcost.sysrowid = @partlot_sysrow
						where partfifocost.sysrowid = @partfifocost_sysrowid
				end
			end
		end
		else
		begin
			update partfifocost 
			set onhandqty = @partfifocost_onhandqtynew ,
			ConsumedQty = case when @partfifocost_onhandqtynew = 0 then PartFIFOCost.OrigOnHandQty else 
				case when @partfifocost_origonhandqty - @partfifocost_onhandqtynew < 0 then 0 else
					@partfifocost_origonhandqty - @partfifocost_onhandqtynew end end,
			inactive = case when @partfifocost_onhandqtynew = 0 then 1 else 0 end,
			fifomaterialcost = isnull(t.mtlunitcost,fifomaterialcost),
			fifolaborcost = isnull(t.lbrunitcost,fifolaborcost),
			fifoburdencost = isnull(t.burunitcost,fifoburdencost),
			fifosubcontcost = isnull(t.subunitcost,fifosubcontcost),
			fifomtlburcost  = isnull(t.mtlburunitcost,fifomtlburcost),
			origonhandqty = @partfifocost_origonhandqty
			from erp.PartFIFOCost partfifocost
			left outer join erp.partfifotran t on t.sysrowid = @partfifotransysrowid
			where partfifocost.SysRowID = @partfifocost_sysrowid

			if @partfifocost_onhandqtynew = 0
				delete from erp.partfifocost 
				where partfifocost.sysrowid = @partfifocost_sysrowid and  partfifocost.origonhandqty = 0
		end
		commit tran -- ds generated

		FETCH NEXT FROM updinfo_cursor into @partfifocost_company, @partfifocost_partnum, @partfifocost_costid,
			@partfifocost_lotnum, @partplant_costmethod, @partfifocost_sysrowid, @partfifocost_onhandqtynew, @partplant_sysrow, @partfifotransysrowid, @partfifocost_origonhandqty
    END
	close updinfo_cursor;
	deallocate updinfo_cursor;
end

if exists (select name from tempdb.sys.tables where name like '%#bincost%')
				drop table #bincost
go
