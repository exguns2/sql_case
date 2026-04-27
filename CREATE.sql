-- 1. Tarifeler Tablosu (Önce bunu oluşturmalısın çünkü müşteriler buna bağlı olacak)
CREATE TABLE TARIFFS (
    TARIFF_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(100) NOT NULL,
    MONTHLY_FEE NUMBER(10, 2),
    DATA_LIMIT_GB NUMBER,
    MINUTES_LIMIT NUMBER,
    SMS_LIMIT NUMBER
);

-- 2. Müşteriler Tablosu
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(50),
    CITY VARCHAR2(50),
    SIGNUP_DATE DATE,
    TARIFF_ID NUMBER,
    CONSTRAINT fk_customer_tariff FOREIGN KEY (TARIFF_ID) REFERENCES TARIFFS(TARIFF_ID)
);

CREATE TABLE MONTHLY_STATS (
    ID NUMBER PRIMARY KEY,
    CUSTOMER_ID NUMBER,
    DATA_USAGE NUMBER(10, 2), -- Ondalıklı kullanım verisi için
    MINUTE_USAGE NUMBER,
    SMS_USAGE NUMBER,
    PAYMENT_STATUS VARCHAR2(20), -- PAID, LATE, UNPAID gibi durumlar için
    CONSTRAINT fk_stats_customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
);

-- 3. Kullanım Kayıtları veya Faturalar (CSV dosyalarına göre ekleyebilirsin)
SELECT owner, table_name 
FROM all_tables 
WHERE table_name IN ('TARIFFS', 'CUSTOMERS', 'MONTHLY_STATS');
