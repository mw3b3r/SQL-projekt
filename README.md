# SQL-projekt
Tohle je složka k SQL projektu pro Engeto

# Report: Analýza průměrných cen šunkového salámu

**Status:** ✅ Dokončeno  
**Technologie:** SQL  

**Zadání:**  
Cílem bylo vypočítat průměrnou cenu šunkového salámu v jednotlivých krajích České republiky na základě dostupných dat z měření. Výsledkem měl být detailní přehled s ponecháním jednotlivých historických záznamů o cenách, doplněný o nový sloupec s celkovým průměrem za daný kraj.

**Použitý datový model:**  
Úloha byla vyřešena nad relačním modelem zahrnujícím tabulky `czechia_price`, `czechia_price_category` a `czechia_region`.

**Metodika řešení:**  
Místo klasického seskupování dat (`GROUP BY`), které by vedlo ke ztrátě detailních řádků, byla pro výpočet úspěšně implementována **okenní funkce** (Window Function). 

Pracovní postup zahrnoval tyto kroky:
* Připojení číselníků krajů a kategorií k hlavní tabulce cen.
* Vyfiltrování záznamů pouze pro "Šunkový salám".
* Aplikaci klauzule `AVG(cp.value) OVER(PARTITION BY cp.region_code)`.

**Shrnutí výpočetní logiky:**  
Příkaz `PARTITION BY` rozdělil datovou sadu do virtuálních bloků (oken) podle kódu kraje. Funkce `AVG()` následně spočítala průměr striktně v rámci těchto bloků. Zjištěná průměrná hodnota pro konkrétní kraj se pak propsala ke každému odpovídajícímu řádku. Původní granularita dat (jednotlivá měření v čase) tak zůstala plně zachována.

Skript je otestovaný a kompletně připravený k nasazení.
