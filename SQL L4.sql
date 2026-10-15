-- SYNTAXE JOIN
-- INNER JOIN tabulka ON sloupectab1 = sloupectab2

-- Spojte tabulky czechia_price a czechia_price_category. 
-- Vypište všechny dostupné sloupce.

select *
from czechia_price
inner join czechia_price_category on czechia_price.category_code = czechia_price_category.code;

-- použití aliasu

select *
from czechia_price as cp
join czechia_price_category as cpc on cp.category_code = cpc.code;

-- Předchozí příklad upravte tak, že vhodně přejmenujete tabulky 
-- a vypíšete ID a jméno kategorie potravin a cenu.

select 
	cp.id,
	cpc.name as produkt,
	cp.value as cena
from czechia_price as cp
join czechia_price_category as cpc on cp.category_code = cpc.code;

-- Přidejte k tabulce cen potravin i informaci o krajích ČR 
-- a vypište informace o cenách společně s názvem kraje.

select 
	cp.id,
	cpc.name as produkt,
	cp.value as cena,
	cr.name as nazev_kraje
from czechia_price as cp
join czechia_price_category as cpc on cp.category_code = cpc.code
join czechia_region as cr on cr.code = cp.region_code;
-- je jedno v jakém pořadí je =, jestli cr=cp nebo cp=cr, výsledek je stejný
-- 101 032 záznamů. Co je výsledkem JOINU? Jen záznamy, kde je v obou tabulkách vyplněný kod regionu. 
-- CO když ale někde chybí? Zjistím to tímhle dotazem? 
-- Ne. Musím použít jiný JOIN

select 
	cp.id,
	cpc.name as produkt,
	cp.value as cena,
	cr.name as nazev_kraje
from czechia_price as cp
left join czechia_price_category as cpc on cp.category_code = cpc.code
right join czechia_region as cr on cr.code = cp.region_code;

-- NULL hodnoty detailně
select
	cp.*,
	cr."name" as nazev_kraje
from czechia_price cp 
left join czechia_region cr on cp.region_code = cr.code 
where 
	cp.region_code is null
	
-- K tabulce czechia_payroll připojte všechny okolní tabulky. 
-- Využijte ERD model ke zjištění, které to jsou.

select
	cp.id,
	cpc.*,
	cpib.*,
	cpu.*,
	cpvt.*
from czechia_payroll cp
join czechia_payroll_calculation cpc on cp.calculation_code = cpc.code 
join czechia_payroll_industry_branch cpib on cp.industry_branch_code = cpib.code 
join czechia_payroll_unit cpu on cp.unit_code  = cpu.code 
join czechia_payroll_value_type cpvt on cp.value_type_code  = cpvt.code;
;

-- Napojovat můžete cokoli na cokoli, ale ne vždy to dává smysl.
-- Pokud máte tabulky nepropojené klíčem, i tak je můžete spojit. Stačí aby měly sloupce se stejnými daty (Např. seznam zemí)
-- Co když je ale v jedné tabulce Czech Republic a v druhé Czechia? Propojí se záznamy? 
-- Tabulky: Countries a Covid19_basic mají obě sloupce se zeměmi. 

select *
from countries c 
join covid19_basic cb on c.country  = cb.country
where c.country in ('Czechia', 'Czech Republic');

select distinct c.country
from countries c; 


select distinct cb.country
from covid19_basic cb ; 


SELECT *
FROM countries AS c 
JOIN covid19_basic AS cb 
	ON c.country = cb.country
	OR c.country = 'Czech Republic' AND cb.country = 'Czechia'
WHERE c.country IN ('Czechia', 'Czech Republic');

-- KARTÉZSKÝ SOUČIN A CROSS JOIN (dva typy zápisu, stejný výsledek)
-- -------------------------------------------------------------------------------------------------------------
-- Každá hodnota z jedné tabulky se rponásobí s jinou kombinacé z druhé= tabulky
-- pokud se nepohlídají podmínky, vznikne extrémně moc kombinací irelevantních dat. 
-- není potřegba mít stejný počet řádků v obou tabulkách

-- Každý záznam s každým
select *
from czechia_price, czechia_price_category;

-- Musím omezit cross join na smysluplné kombinace
select *
from czechia_price cp, czechia_price_category cpc
where cp.category_code = cpc.code; 

-- Učebnicově správně cross join
select *
from czechia_region cr 
cross join czechia_region cr2 
where cr.code !=cr2.code  and cr.code <cr2.code ;

-- MNOŽINOVÉ OPERACE
-- ---------------------------------------------------------------------------------------------------

-- Přepište následující dotaz na variantu spojení dvou separátních 
-- dotazů se selekcí pro každý kraj zvlášť.

select *
from czechia_price cp 
where cp.region_code in ('CZ064', 'CZ010');

-- jak by to vypadalo v UNION
select *
from czechia_price cp 
where cp.region_code = 'CZ064'
union
select *
from czechia_price cp 
where cp.region_code = 'CZ010';

-- UNION ALL  - spojí všechno z obou dvou množin dohromady
-- UNION - spojí jen unikátní záznamy a odstraní duplicity

-- Co když bude jiný počet sloupců? 
select 
	cp.category_code,
	cp.region_code,
	cp.value
from czechia_price cp 
where cp.region_code = 'CZ064'
union
select 
	cp.category_code ,
	cp.region_code,
	cp.value 
from czechia_price cp 
where cp.region_code = 'CZ010';

-- Co když sloupce prohodím? Hodnoty se namíchají
select 
	cp.category_code,
	cp.value,
	cp.region_code	
from czechia_price cp 
where cp.region_code = 'CZ064'
union
select 
	cp.category_code ,
	cp.region_code,
	cp.value 
from czechia_price cp 
where cp.region_code = 'CZ010';

-- Sjednoťe kraje a okresy do jedné množiny. 
-- Tu následně seřaďte dle kódu vzestupně.

select *
from czechia_district cd
union
select *
from czechia_region cr
order by name ASC; 


-- Stejný příklad jako o něco výše, jen INTERSECT(co mají společného) a 
-- EXCEPT (co mají odlišného) místo UNION
select 
	cp.category_code,
	cp.region_code,
	cp.value
from czechia_price cp 
where cp.region_code = 'CZ064'
except
select 
	cp.category_code ,
	cp.region_code,
	cp.value 
from czechia_price cp 
where cp.region_code = 'CZ010';

-- Propojení nesouvisejících tabulek

select
	hp.name,
	hp.provider_id 
from healthcare_provider hp
union
select
	cpc.name,
	cpc.code
from czechia_price_category cpc
order by name DESC ; 


-- Propojení covid19_basic a countries spojit podle názvu země
-- a odstranit duplicitní záznamy, seřaďte to podle abecedy

select
	cb.country 
from covid19_basic cb
union
select
	c.country 
from countries c
order by country; 