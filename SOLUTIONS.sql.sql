/* 1.1 
Açıklama: Bu sorguda CUSTOMERS tablosu ile TARIFFS tablosunu TARIFF_ID üzerinden birleştiriyoruz. 
WHERE koşulu ile sadece tarife adı 'Kobiye Destek' olanları filtreleyerek müşterilerin tüm bilgilerini getiriyoruz. 
Bu işlem, veritabanı normalizasyonu gereği iki tabloyu ilişkilendirerek veri çekmemizi sağlar.
*/
SELECT c.* FROM CUSTOMERS c
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek';

/* 1.2 
Açıklama: 'Kobiye Destek' tarifesindeki müşterileri SIGNUP_DATE kolonuna göre azalan (DESC) şekilde sıralıyoruz. 
Bu sayede en son kayıt olan müşteri listenin en başında yer alır. 
FETCH FIRST 1 ROWS ONLY komutu ile sadece en güncel kayda ulaşıyoruz.
*/
SELECT c.* FROM CUSTOMERS c
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE t.NAME = 'Kobiye Destek'
ORDER BY c.SIGNUP_DATE DESC
FETCH FIRST 1 ROWS ONLY;

/* 2.1 
Açıklama: Bu sorgu, her bir tarifeye kaç müşterinin kayıtlı olduğunu gösteren bir dağılım istatistiği sunar. 
GROUP BY TARIFF_ID kullanarak müşterileri tarifelerine göre gruplandırıyoruz. 
COUNT(*) fonksiyonu ile her gruptaki (tarifedeki) toplam müşteri sayısını hesaplıyoruz.
*/
SELECT TARIFF_ID, COUNT(*) AS MUSTERI_SAYISI 
FROM CUSTOMERS 
GROUP BY TARIFF_ID;

/* 3.1 
Açıklama: En eski müşterileri bulmak için kayıt tarihine (SIGNUP_DATE) göre artan (ASC) sıralama yapıyoruz. 
Soruda belirtildiği üzere en düşük ID her zaman en eski müşteri anlamına gelmediğinden tarih bazlı sıralama en doğru yaklaşımdır.
*/
SELECT * FROM CUSTOMERS 
ORDER BY SIGNUP_DATE ASC;

/* 3.2 
Açıklama: İlk kayıt olan (örneğin ilk 100) müşterinin şehirlere göre nasıl dağıldığını analiz ediyoruz.
Alt sorgu ile en eski kayıtları çekip, ana sorguda bu kayıtları şehirlerine göre gruplayarak adetlerini sayıyoruz.
*/
SELECT CITY, COUNT(*) AS OLDEST_CUSTOMER_COUNT
FROM (SELECT * FROM CUSTOMERS ORDER BY SIGNUP_DATE ASC FETCH FIRST 100 ROWS ONLY)
GROUP BY CITY;

/* 4.1 
Açıklama: CUSTOMERS tablosu ile MONTHLY_STATS tablosunu LEFT JOIN ile birleştiriyoruz. 
Kullanım tablosunda (MONTHLY_STATS) karşılığı olmayan (IS NULL) müşterileri filtreleyerek kayıt hatası olanları buluyoruz.
*/
SELECT c.CUSTOMER_ID 
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.CUSTOMER_ID IS NULL;

/* 4.2 
Açıklama: Kullanım kaydı eksik olan müşterileri şehir bazlı gruplandırıyoruz.
Bu sayede sistemsel hatanın belirli bir bölgeye mi ait olduğunu yoksa genel mi olduğunu anlayabiliriz.
*/
SELECT c.CITY, COUNT(*) AS MISSING_RECORD_COUNT
FROM CUSTOMERS c
LEFT JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
WHERE m.CUSTOMER_ID IS NULL
GROUP BY c.CITY;

/* 5.1 
Açıklama: Müşterinin aylık kullanımını (DATA_USAGE) tarifesindeki limit (DATA_LIMIT) ile oranlıyoruz. 
WHERE bloğundaki matematiksel işlemle, kullanımın limitin 0.75 katından büyük veya eşit olduğu durumları filtreliyoruz. 
Bu sorgu, kota aşımına yaklaşan müşterileri tespit etmek için kullanılır.
*/
SELECT c.NAME, m.DATA_USAGE, t.DATA_LIMIT_GB
FROM CUSTOMERS c
JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE m.DATA_USAGE >= (t.DATA_LIMIT_GB * 0.75);

/* 5.2 
Açıklama: Bu sorguda müşterinin veri, dakika ve SMS kullanımlarının tamamının limitlerine ulaşıp ulaşmadığını kontrol ediyoruz.
AND operatörü kullanarak her üç limitin de (>=) dolmuş olduğu 'hard user' müşterileri tespit ediyoruz.
*/
SELECT c.NAME
FROM CUSTOMERS c
JOIN MONTHLY_STATS m ON c.CUSTOMER_ID = m.CUSTOMER_ID
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
WHERE m.DATA_USAGE >= t.DATA_LIMIT_GB 
  AND m.MINUTE_USAGE >= t.MINUTES_LIMIT
  AND m.SMS_USAGE >= t.SMS_LIMIT;

/* 6.1
Açıklama: MONTHLY_STATS tablosundaki PAYMENT_STATUS kolonunu 'UNPAID' (ödenmemiş) olarak filtreliyoruz.
Bu sayede borcu olan müşterilerin listesini finansal takip amacıyla elde ediyoruz.
*/
SELECT * FROM MONTHLY_STATS WHERE PAYMENT_STATUS = 'UNPAID';

/* 6.2 
Açıklama: Ödeme durumlarının (PAID, UNPAID, LATE) tarifelere göre dağılımını analiz ediyoruz.
Bu sorgu, hangi tarife grubunun ödeme sadakatinin daha yüksek olduğunu anlamamıza yardımcı olur.
*/
SELECT t.NAME, m.PAYMENT_STATUS, COUNT(*) AS STATUS_COUNT
FROM MONTHLY_STATS m
JOIN CUSTOMERS c ON m.CUSTOMER_ID = c.CUSTOMER_ID
JOIN TARIFFS t ON c.TARIFF_ID = t.TARIFF_ID
GROUP BY t.NAME, m.PAYMENT_STATUS
ORDER BY t.NAME;