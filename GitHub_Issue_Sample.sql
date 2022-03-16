-- dpsdata."Schools_Current" source

create or replace
view dpsdata."Schools_Current"
as
select
	row_number() over (
	order by
		main.schnum
		, main.buildingid
	) as objectid
	,
    main.schnum
	,
    main.abbreviation
	,
    main.school_name
	,
    main.elem
	,
    main.mid
	,
    main.high
	,
    main.school_level
	,
    main.b_elem
	,
    main.b_mid
	,
    main.b_high
	,
    main.classification
	,
    main.current_config
	,
    main.final_config
	,
    main.label_x
	,
    main.label_y
	,
    main.buildingid
	,
    main.geom
from
	(
		select
			p.schnum
			,
            p.abbreviation
			,
            p.school_name
			,
            p.elem
			,
            p.mid
			,
            p.high
			,
            p.school_level
			,
            p.b_elem
			,
            p.b_mid
			,
            p.b_high
			,
            p.classification
			,
            p.current_config
			,
            p.final_config
			,
            c.label_x
			,
            c.label_y
			,
            p.buildingid
			,
            b.geom
		from
			"Program_Details" p
		left join carto."Schools_Carto" c on
			p.schnum = c.schnum
			and p.buildingid::text = c.buildingid::text
		left join "DPS_Buildings" b on
			p.buildingid::text = b.dps_building_number::text
		where
			p.school_year = (
				(
					select
						"School_Year".ods_year
					from
						"School_Year"
					where
						"School_Year".year_name::text = 'current'::text
				)
			)
			and p.status::bpchar <> 'Closed'::bpchar
	) main;