--Generate aggregate monthly med claims from Production tables:
SELECT employers.name,employer_id, /*hcrm_data_source_id,*/ TO_CHAR(claims.paid_date, 'YYYY-MM') AS paid_month, SUM(amount_paid) AS paid_amount
FROM claims INNER JOIN individuals ON individual_id = individuals.id
INNER JOIN employers ON employer_id = employers.id
/*WHERE employer_id IN ('3260') GROUP BY employers.name,paid_month, individuals.employer_id*/
WHERE employer_id IN ('172') --and hcrm_data_source_id=93 
GROUP BY /*hcrm_data_source_id,*/employers.name,paid_month, individuals.employer_id
ORDER BY /*hcrm_data_source_id,*/employers.name,individuals.employer_id,paid_month;

--Generate aggregate monthly rx claims from Production tables:
SELECT employers.name,employer_id, TO_CHAR(rx_claims.paid_date, 'YYYY-MM') AS paid_month, SUM(amount_paid) AS paid_amount
FROM rx_claims INNER JOIN individuals ON individual_id = individuals.id
INNER JOIN employers ON employer_id = employers.id
WHERE group_number IN ('ALEPR',
'AONEX',
'BBMOL',
'BECOS') --and hcrm_data_source_id = 93
--WHERE employer_id IN ('6285')
GROUP BY employers.name,paid_month, individuals.employer_id
ORDER BY employers.name,individuals.employer_id,paid_month;

--Generate aggregate monthly population number from Production tables:
SELECT relationship_code, COUNT(*) FROM "populations" WHERE "populations"."employer_id" = '7999' AND (
     EXISTS(
       SELECT 1
       FROM individual_eligibility_months iem
       WHERE iem.individual_id = populations.individual_id
     AND iem.eligible_month BETWEEN
       '2018-07-01' AND '2018-07-31' LIMIT 1))
       GROUP BY relationship_code;