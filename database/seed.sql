INSERT INTO labs (name, description, address, city, rating, review_count, home_collection)
VALUES
('HealthFirst Diagnostics', 'Reliable routine and preventive health testing.', 'Connaught Place, New Delhi', 'Delhi', 4.7, 1240, TRUE),
('CityCare Labs', 'Convenient diagnostic services with digital reports.', 'Rajouri Garden, New Delhi', 'Delhi', 4.5, 860, TRUE),
('PrimePath Diagnostics', 'Specialised pathology and wellness testing.', 'Dwarka Sector 12, New Delhi', 'Delhi', 4.6, 970, TRUE),
('Metro Diagnostics', 'Accessible lab testing and sample collection.', 'Lajpat Nagar, New Delhi', 'Delhi', 4.3, 540, TRUE),
('Wellness Clinical Lab', 'Preventive screening and routine pathology.', 'Rohini Sector 10, New Delhi', 'Delhi', 4.4, 690, TRUE),
('Aarogya Diagnostics', 'Local diagnostic centre with a broad test menu.', 'Janakpuri, New Delhi', 'Delhi', 4.2, 410, TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO tests (name, slug, category, description, preparation, report_time)
VALUES
('Complete Blood Count (CBC)', 'complete-blood-count-cbc', 'Blood', 'Measures key components of blood, including red cells, white cells and platelets.', 'Usually no special preparation is needed.', 'Same day'),
('Lipid Profile', 'lipid-profile', 'Heart', 'Measures cholesterol and triglyceride levels.', 'Fasting may be requested by your clinician or lab.', 'Same day'),
('Liver Function Test (LFT)', 'liver-function-test', 'Liver', 'Measures enzymes and proteins that help assess liver function.', 'Follow the lab instructions; disclose medicines to your clinician.', 'Same day'),
('Thyroid Profile (TSH)', 'thyroid-profile-tsh', 'Hormones', 'Measures thyroid-stimulating hormone.', 'Usually no special preparation is needed.', 'Same day'),
('HbA1c', 'hba1c', 'Diabetes', 'Estimates average blood glucose over roughly the previous three months.', 'Fasting is generally not required.', '24 hours'),
('Vitamin D', 'vitamin-d', 'Vitamins', 'Measures 25-hydroxy vitamin D in blood.', 'Usually no special preparation is needed.', '24-48 hours')
ON CONFLICT (slug) DO NOTHING;

-- Add comparable demo prices for every seeded lab/test pair.
INSERT INTO lab_test_prices (lab_id, test_id, price, original_price, available)
SELECT l.id, t.id,
       CASE t.slug
         WHEN 'complete-blood-count-cbc' THEN 299
         WHEN 'lipid-profile' THEN 499
         WHEN 'liver-function-test' THEN 599
         WHEN 'thyroid-profile-tsh' THEN 399
         WHEN 'hba1c' THEN 349
         WHEN 'vitamin-d' THEN 799
         ELSE 499
       END + (ROW_NUMBER() OVER (PARTITION BY t.id ORDER BY l.name) * 10),
       CASE t.slug
         WHEN 'complete-blood-count-cbc' THEN 450
         WHEN 'lipid-profile' THEN 750
         WHEN 'liver-function-test' THEN 900
         WHEN 'thyroid-profile-tsh' THEN 650
         WHEN 'hba1c' THEN 550
         WHEN 'vitamin-d' THEN 1100
         ELSE 700
       END,
       TRUE
FROM labs l CROSS JOIN tests t
WHERE NOT EXISTS (
  SELECT 1 FROM lab_test_prices p WHERE p.lab_id = l.id AND p.test_id = t.id
);
