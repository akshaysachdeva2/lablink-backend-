
BEGIN;

-- =========================================
-- 1. SEED 20 LABORATORIES
-- =========================================

INSERT INTO labs (name, description, address, city, rating, review_count, home_collection)
SELECT s.name, s.description, s.address, 'Delhi', s.rating, s.review_count, s.home_collection
FROM (VALUES
  ('HealthFirst Diagnostics', 'Reliable routine and preventive health testing.', 'Connaught Place, New Delhi', 4.7, 1240, TRUE),
  ('CityCare Labs', 'Convenient diagnostic services with digital reports.', 'Rajouri Garden, New Delhi', 4.5, 860, TRUE),
  ('PrimePath Diagnostics', 'Specialised pathology and wellness testing.', 'Dwarka Sector 12, New Delhi', 4.6, 970, TRUE),
  ('Metro Diagnostics', 'Accessible lab testing and sample collection.', 'Lajpat Nagar, New Delhi', 4.3, 540, TRUE),
  ('Wellness Clinical Lab', 'Preventive screening and routine pathology.', 'Rohini Sector 10, New Delhi', 4.4, 690, TRUE),
  ('Aarogya Diagnostics', 'Local diagnostic centre with a broad test menu.', 'Janakpuri, New Delhi', 4.2, 410, TRUE),
  ('MediScan Diagnostics', 'Modern diagnostic and pathology services.', 'Karol Bagh, New Delhi', 4.6, 780, TRUE),
  ('Apollo Pathology Centre', 'Comprehensive diagnostic testing services.', 'Saket, New Delhi', 4.8, 1500, TRUE),
  ('LifeLine Diagnostics', 'Routine and specialised laboratory testing.', 'Pitampura, New Delhi', 4.4, 620, TRUE),
  ('CarePlus Laboratory', 'Affordable diagnostic and preventive screening.', 'Vasant Kunj, New Delhi', 4.3, 510, TRUE),
  ('Accurate Diagnostics', 'Precision-focused pathology services.', 'Mayur Vihar, New Delhi', 4.5, 720, TRUE),
  ('HealthBridge Labs', 'Convenient testing with home sample collection.', 'Preet Vihar, New Delhi', 4.6, 890, TRUE),
  ('National Diagnostic Centre', 'Wide range of routine laboratory tests.', 'Patel Nagar, New Delhi', 4.2, 380, TRUE),
  ('Redcliffe Diagnostics', 'Digital-first diagnostic testing services.', 'Greater Kailash, New Delhi', 4.7, 1100, TRUE),
  ('MedSure Labs', 'Preventive health packages and pathology testing.', 'Model Town, New Delhi', 4.4, 570, TRUE),
  ('Urban Health Diagnostics', 'Neighbourhood diagnostic and blood testing.', 'Shahdara, New Delhi', 4.1, 340, TRUE),
  ('PrimeCare Pathology', 'Pathology and wellness screening services.', 'Green Park, New Delhi', 4.6, 810, TRUE),
  ('TrustMed Diagnostics', 'Reliable diagnostic services and reporting.', 'Tilak Nagar, New Delhi', 4.3, 460, TRUE),
  ('CityMed Laboratory', 'Routine and specialised blood investigations.', 'Civil Lines, New Delhi', 4.5, 650, TRUE),
  ('Global Health Labs', 'Comprehensive preventive diagnostic services.', 'Punjabi Bagh, New Delhi', 4.7, 980, TRUE)
) AS s(name, description, address, rating, review_count, home_collection)
WHERE NOT EXISTS (
  SELECT 1 FROM labs existing WHERE existing.name = s.name
);

-- =========================================
-- 2. SEED 10 DIAGNOSTIC TESTS
-- =========================================

INSERT INTO tests (name, slug, category, description, preparation, report_time)
VALUES
(
  'Complete Blood Count (CBC)',
  'complete-blood-count-cbc',
  'Blood',
  'Measures red blood cells, white blood cells and platelets.',
  'Usually no special preparation is needed.',
  'Same day'
),
(
  'Lipid Profile',
  'lipid-profile',
  'Heart',
  'Measures cholesterol and triglyceride levels.',
  'Fasting may be requested by your clinician or lab.',
  'Same day'
),
(
  'Liver Function Test (LFT)',
  'liver-function-test',
  'Liver',
  'Measures enzymes and proteins that help assess liver function.',
  'Follow the laboratory instructions.',
  'Same day'
),
(
  'Thyroid Profile (TSH)',
  'thyroid-profile-tsh',
  'Hormones',
  'Measures thyroid-stimulating hormone.',
  'Usually no special preparation is needed.',
  'Same day'
),
(
  'HbA1c',
  'hba1c',
  'Diabetes',
  'Estimates average blood glucose over roughly three months.',
  'Fasting is generally not required.',
  '24 hours'
),
(
  'Vitamin D',
  'vitamin-d',
  'Vitamins',
  'Measures 25-hydroxy vitamin D levels in blood.',
  'Usually no special preparation is needed.',
  '24-48 hours'
),
(
  'Vitamin B12',
  'vitamin-b12',
  'Vitamins',
  'Measures vitamin B12 levels in blood.',
  'Follow laboratory instructions.',
  '24-48 hours'
),
(
  'Kidney Function Test (KFT)',
  'kidney-function-test-kft',
  'Kidney',
  'Measures markers such as urea and creatinine to assess kidney function.',
  'Follow laboratory instructions.',
  'Same day'
),
(
  'Iron Studies',
  'iron-studies',
  'Blood',
  'Evaluates iron levels and related markers in the blood.',
  'Fasting may be requested by your clinician or lab.',
  '24 hours'
),
(
  'Urine Routine Test',
  'urine-routine-test',
  'Urine',
  'Examines urine for physical, chemical and microscopic abnormalities.',
  'A clean-catch urine sample may be required.',
  'Same day'
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  description = EXCLUDED.description,
  preparation = EXCLUDED.preparation,
  report_time = EXCLUDED.report_time,
  is_active = TRUE;

-- =========================================
-- 3. GENERATE LAB-TEST PRICES AND AVAILABILITY
-- =========================================

WITH lab_list AS (
  SELECT
    id,
    name,
    ROW_NUMBER() OVER (ORDER BY name)::INTEGER AS lab_no
  FROM labs
  WHERE name IN (
    'HealthFirst Diagnostics', 'CityCare Labs',
    'PrimePath Diagnostics', 'Metro Diagnostics',
    'Wellness Clinical Lab', 'Aarogya Diagnostics',
    'MediScan Diagnostics', 'Apollo Pathology Centre',
    'LifeLine Diagnostics', 'CarePlus Laboratory',
    'Accurate Diagnostics', 'HealthBridge Labs',
    'National Diagnostic Centre', 'Redcliffe Diagnostics',
    'MedSure Labs', 'Urban Health Diagnostics',
    'PrimeCare Pathology', 'TrustMed Diagnostics',
    'CityMed Laboratory', 'Global Health Labs'
  )
),
test_list AS (
  SELECT
    id,
    slug,
    ROW_NUMBER() OVER (ORDER BY slug)::INTEGER AS test_no,
    CASE slug
      WHEN 'complete-blood-count-cbc' THEN 300
      WHEN 'lipid-profile' THEN 500
      WHEN 'liver-function-test' THEN 600
      WHEN 'thyroid-profile-tsh' THEN 400
      WHEN 'hba1c' THEN 350
      WHEN 'vitamin-d' THEN 800
      WHEN 'vitamin-b12' THEN 700
      WHEN 'kidney-function-test-kft' THEN 550
      WHEN 'iron-studies' THEN 650
      WHEN 'urine-routine-test' THEN 250
    END AS base_price
  FROM tests
  WHERE slug IN (
    'complete-blood-count-cbc',
    'lipid-profile',
    'liver-function-test',
    'thyroid-profile-tsh',
    'hba1c',
    'vitamin-d',
    'vitamin-b12',
    'kidney-function-test-kft',
    'iron-studies',
    'urine-routine-test'
  )
)
INSERT INTO lab_test_prices (lab_id, test_id, price, original_price, available)
SELECT
  l.id,
  t.id,
  (t.base_price + (l.lab_no * 13) + ((l.lab_no * t.test_no) % 5) * 17)::NUMERIC(10,2),
  (t.base_price + 180 + (l.lab_no * 5))::NUMERIC(10,2),
  ((l.lab_no + t.test_no) % 4 <> 0)
FROM lab_list l
CROSS JOIN test_list t
ON CONFLICT (lab_id, test_id)
DO UPDATE SET
  price = EXCLUDED.price,
  original_price = EXCLUDED.original_price,
  available = EXCLUDED.available;

COMMIT;

-- =========================================
-- 4. VERIFY SEEDED DATA
-- =========================================

SELECT 'Laboratories' AS item, COUNT(*) AS total
FROM labs
WHERE name IN (
  'HealthFirst Diagnostics', 'CityCare Labs',
  'PrimePath Diagnostics', 'Metro Diagnostics',
  'Wellness Clinical Lab', 'Aarogya Diagnostics',
  'MediScan Diagnostics', 'Apollo Pathology Centre',
  'LifeLine Diagnostics', 'CarePlus Laboratory',
  'Accurate Diagnostics', 'HealthBridge Labs',
  'National Diagnostic Centre', 'Redcliffe Diagnostics',
  'MedSure Labs', 'Urban Health Diagnostics',
  'PrimeCare Pathology', 'TrustMed Diagnostics',
  'CityMed Laboratory', 'Global Health Labs'
)
UNION ALL
SELECT 'Diagnostic Tests', COUNT(*)
FROM tests
WHERE slug IN (
  'complete-blood-count-cbc', 'lipid-profile',
  'liver-function-test', 'thyroid-profile-tsh',
  'hba1c', 'vitamin-d', 'vitamin-b12',
  'kidney-function-test-kft', 'iron-studies',
  'urine-routine-test'
)
UNION ALL
SELECT 'Available Price Records', COUNT(*)
FROM lab_test_prices p
JOIN labs l ON l.id = p.lab_id
WHERE p.available = TRUE
AND l.name IN (
  'HealthFirst Diagnostics', 'CityCare Labs',
  'PrimePath Diagnostics', 'Metro Diagnostics',
  'Wellness Clinical Lab', 'Aarogya Diagnostics',
  'MediScan Diagnostics', 'Apollo Pathology Centre',
  'LifeLine Diagnostics', 'CarePlus Laboratory',
  'Accurate Diagnostics', 'HealthBridge Labs',
  'National Diagnostic Centre', 'Redcliffe Diagnostics',
  'MedSure Labs', 'Urban Health Diagnostics',
  'PrimeCare Pathology', 'TrustMed Diagnostics',
  'CityMed Laboratory', 'Global Health Labs'
);
