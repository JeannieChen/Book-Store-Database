CREATE TABLE ADDRESS 
( street VARCHAR(30) NOT NULL,
  zipcode VARCHAR(20) NOT NULL,
  PRIMARY KEY(street, zipcode) );
CREATE TABLE AUTHOR
( Fname VARCHAR(20) NOT NULL, 
  Mname VARCHAR(20),
  Lname VARCHAR(20) NOT NULL,
  phone_num VARCHAR(20) NOT NULL,
  PRIMARY KEY(phone_num)  );
CREATE TABLE AUTHOR_WRITE_BOOK
( ISBN INT NOT NULL,
  Aphone_num VARCHAR(20) NOT NULL,  
  PRIMARY KEY(ISBN, Aphone_num),
  CONSTRAINT AWBFKA
  FOREIGN KEY(Aphone_num) REFERENCES AUTHOR(phone_num)
  ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT AWBFKB
   FOREIGN KEY(ISBN) REFERENCES BOOK(ISBN)
  ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE BOOK
( ISBN VARCHAR(13) NOT NULL,
  Pname VARCHAR(100),
  edition INT,
  publish_date YEAR(4),
  price real,
  title VARCHAR(300),
  sales_amount INT,
  PRIMARY KEY(ISBN),
  CONSTRAINT BPFK
  FOREIGN KEY(Pname) REFERENCES PUBLISHER(name)
  ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE BOOK_BELONGS_TO_CATEGORY
( ISBN VARCHAR(13) NOT NULL,
  category_name VARCHAR(50) NOT NULL,
  PRIMARY KEY(ISBN, category_name),
  CONSTRAINT ISBNFK
  FOREIGN KEY(ISBN) REFERENCES BOOK(ISBN)
  ON DELETE SET NULL  ON UPDATE CASCADE,
  CONSTRAINT CATEFK
  FOREIGN KEY(category_name) REFERENCES CATEGORY(category_name)
);
CREATE TABLE BOOK_HAS_TRANSACTION
( ISBN VARCHAR(13) NOT NULL,
  transaction_id VARCHAR(30) NOT NULL,
  PRIMARY KEY(ISBN, transaction_id),
  CONSTRAINT ISBNFK
  FOREIGN KEY(ISBN) REFERENCES BOOK(ISBN)
  ON DELETE SET NULL  ON UPDATE CASCADE,
  CONSTRAINT TIDFK
  FOREIGN KEY(transaction_id) REFERENCES TRANSACTION_HISTORY(transaction_id)
  ON DELETE SET NULL  ON UPDATE CASCADE
);
CREATE TABLE CATEGORY
( name VARCHAR(200)  NOT NULL,
  PRIMARY KEY(name)  );
CREATE TABLE COURSE
( course_num VARCHAR(15) NOT NULL,
  PRIMARY KEY(course_num)
);
CREATE TABLE COURSE_USE_BOOK
( course_num VARCHAR(15) NOT NULL,
  ISBN VARCHAR(13) NOT NULL,
  PRIMARY KEY(course_num, ISBN),
  CONSTRAINT COURSENUMFK
  FOREIGN KEY(course_num) REFERENCES COURSE(course_num)
  ON DELETE SET NULL  ON UPDATE CASCADE,
  CONSTRAINT ISBNFK
  FOREIGN KEY(ISBN) REFERENCES BOOK(ISBN)
  ON DELETE SET NULL  ON UPDATE CASCADE
);
CREATE TABLE CUSTOMER
( email VARCHAR(40)  NOT NULL,
  phone_num VARCHAR(20) NOT NULL,
  Fname VARCHAR(30), 
  Lname VARCHAR(30),
  PRIMARY KEY(email)  );
CREATE TABLE CUSTOMER_HAS_ADDRESS
( street VARCHAR(30) NOT NULL,
  zipcode VARCHAR(5) NOT NULL,
  email VARCHAR(40) NOT NULL,
  PRIMARY KEY(street, zipcode, email),
  CONSTRAINT CAFK1
  FOREIGN KEY(street) REFERENCES ADDRESS(street)
  ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT CAFK4
  FOREIGN KEY(zipcode) REFERENCES ADDRESS(zipcode)
  ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT CAFK5
  FOREIGN KEY(email) REFERENCES CUSTOMER(email)
  ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE CUSTOMER_HAS_PAYMENT
( email VARCHAR(40) NOT NULL,
  credit_card_num VARCHAR(19) NOT NULL,
  PRIMARY KEY(email,credit_card_num),
  CONSTRAINT CPCFK
  FOREIGN KEY(email) REFERENCES CUSTOMER(email)
  ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT CPPFK
  FOREIGN KEY(credit_card_num) REFERENCES PAYMENT(credit_card_num)  
  ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE INVENTORY
( inventory_id INT NOT NULL,
  capacity   INT,
  street VARCHAR(30) NOT NULL,
  zipcode VARCHAR(20) NOT NULL,
  PRIMARY KEY(inventory_id),
  CONSTRAINT IAFK
  FOREIGN KEY(street) REFERENCES ADDRESS(street)
  ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY(zipcode) REFERENCES ADDRESS(zipcode)
  ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE INVENTORY_STORE_BOOK
(ISBN VARCHAR(13) NOT NULL,
in_id INT NOT NULL,
amount int not null,
PRIMARY KEY(ISBN, in_id),
CONSTRAINT ISBBFK
FOREIGN KEY(ISBN) REFERENCES BOOK(ISBN)
ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT ISBIFK
FOREIGN KEY(in_id) REFERENCES INVENTORY(inventory_id)
ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE PAYMENT
( credit_card_num VARCHAR(19)  NOT NULL,
  expired_date DATE NOT NULL,
  security_code CHAR(3) NOT NULL,
  street VARCHAR(30) NOT NULL,
  zipcode VARCHAR(20) NOT NULL,
  PRIMARY KEY(credit_card_num),
  CONSTRAINT PAFK
  FOREIGN KEY(street) REFERENCES ADDRESS(street)
  ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY(zipcode) REFERENCES ADDRESS(zipcode)
  ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE TABLE POST_COURSE
( prerequisite_num VARCHAR(15) NOT NULL,
  post_course_num VARCHAR(15) NOT NULL,
  PRIMARY KEY(prerequisite_num, post_course_num),
  CONSTRAINT PREFK
  FOREIGN KEY(prerequisite_num) REFERENCES COURSE(course_num)
  ON DELETE SET NULL  ON UPDATE CASCADE,
  CONSTRAINT POSTFK
  FOREIGN KEY(post_course_num) REFERENCES COURSE(course_num)
  ON DELETE SET NULL  ON UPDATE CASCADE
);
CREATE TABLE PUBLISHER
( name VARCHAR(100)  NOT NULL,
  phone_num VARCHAR(20) NOT NULL,
  PRIMARY KEY(name)  );
CREATE TABLE REVIEW
( r_id VARCHAR(30) NOT NULL,
  Cmail  VARCHAR(40) NOT NULL,
  ISBN VARCHAR(13) NOT NULL,
  rating VARCHAR(3) NOT NULL,
  content VARCHAR(3000),  
 PRIMARY KEY(r_id),
 CONSTRAINT RCFK
 FOREIGN KEY(Cmail) REFERENCES CUSTOMER(email)
 ON DELETE SET NULL  ON UPDATE CASCADE,
 CONSTRAINT RBFK
 FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
 ON DELETE SET NULL  ON UPDATE CASCADE
);
CREATE TABLE TRANSACTION_HISTORY
( transaction_id VARCHAR(30) NOT NULL,
  Cmail VARCHAR(40) NOT NULL,
  date 	DATE,
  sold  BOOLEAN,
return_date 	DATE,
returned BOOLEAN,
amount INT,
PRIMARY KEY(transaction_id),
CONSTRAINT TCFK
FOREIGN KEY(Cmail) REFERENCES CUSTOMER(email)
ON DELETE SET NULL ON UPDATE CASCADE);
CREATE VIEW BEST_PROFITS
AS SELECT B.title, sum(T.amount * B.price) AS profits
FROM BOOK AS B, TRANSACTION_HISTORY AS T, BOOK_has_TRANSACTION AS BT
WHERE T.sold = 'TRUE'
    AND T.transaction_id = BT. transaction_id
    AND BT.ISBN = B.ISBN
GROUP BY BT.ISBN
ORDER BY profits DESC;
CREATE VIEW BEST_SELL
AS SELECT B.title, SUM(T.amount) AS sales
FROM BOOK AS B, TRANSACTION_HISTORY AS T,BOOK_has_TRANSACTION AS BHT
WHERE T.sold = 'TRUE' 
	AND T.transaction_id = BHT.transaction_id
	AND BHT.ISBN = B.ISBN
GROUP BY BHT.ISBN
ORDER BY sales DESC;
CREATE VIEW CPMPA
AS SELECT DISTINCT C.Fname, C.Lname, C.email
FROM CUSTOMER AS C, TRANSACTION_HISTORY AS T, 
BOOK_HAS_TRANSACTION AS BT, AUTHOR_WRITE_BOOK AS AB, MOST_PROFITABLE_AUTHOR AS MPA
WHERE C.email = T.Cmail 
      AND T.transaction_id = BT.transaction_id
      AND BT.ISBN = AB.ISBN
      AND AB.Aphone_num = MPA.phone_num;
CREATE VIEW MOST_POPULAR_AUTHOR
AS SELECT A_1.Fname, A_1.Mname, A_1.Lname, A_1.phone_num
FROM (SELECT max(B.sales_amount) AS max_sales
FROM BOOK AS B, AUTHOR AS A, AUTHOR_WRITE_BOOK AS AB
WHERE B.ISBN = AB.ISBN
      AND AB.Aphone_num = A.phone_num) AS R, BOOK AS B_1, AUTHOR AS A_1,
AUTHOR_WRITE_BOOK AS AB_1
WHERE B_1.ISBN = AB_1.ISBN AND AB_1.Aphone_num = A_1.phone_num AND B_1.sales_amount = max_sales;
CREATE VIEW MOST_PROFITABLE_AUTHOR
AS SELECT A_1.Fname, A_1.Mname, A_1.Lname, A_1.phone_num
FROM (SELECT max(B.sales_amount * B.price) AS max_profits
FROM BOOK AS B, AUTHOR AS A, AUTHOR_WRITE_BOOK AS AB
WHERE B.ISBN = AB.ISBN
      AND AB.Aphone_num = A.phone_num) AS R, BOOK AS B_1, AUTHOR AS A_1,
AUTHOR_WRITE_BOOK AS AB_1
WHERE B_1.ISBN = AB_1.ISBN AND AB_1.Aphone_num = A_1.phone_num AND B_1.sales_amount * B_1.price = max_profits;
CREATE VIEW NEWVIEW_H
AS SELECT DISTINCT A.Fname, A.Mname, A.Lname
FROM more_than_average AS MA, AUTHOR AS A, AUTHOR_WRiTE_BOOK AS AB, 
BOOK_HAS_TRANSACTION AS BT, TRANSACTION_HISTORY AS T, CUSTOMER AS C
WHERE MA.Email_Address = T.Cmail
      AND T.transaction_id = BT.transaction_id
      AND BT.ISBN = AB.ISBN
      AND AB.Aphone_num = A.phone_num;
CREATE VIEW money_spent(Fist_name, Last_name, dollar_spent)
AS SELECT C.Fname, C.Lname, sum(T.amount * B.price)
FROM CUSTOMER C, BOOK B, TRANSACTION_HISTORY T, BOOK_HAS_TRANSACTION BT
WHERE C.email = T.Cmail AND T.transaction_id = BT.transaction_id AND B.ISBN = BT.ISBN
GROUP BY C.email;
CREATE VIEW more_than_average(First_name, Last_name, Email_Address)
AS SELECT Fname, Lname, email
FROM (SELECT Fname, Lname, email, sum(T.amount * B.price) as cost
FROM CUSTOMER C, BOOK B, TRANSACTION_HISTORY T, BOOK_HAS_TRANSACTION BT
WHERE C.email = T.Cmail AND T.transaction_id = BT.transaction_id AND B.ISBN = BT.ISBN
GROUP BY C.email),
 (SELECT avg(dollar_spent) AS avg_spent
  FROM money_spent)
WHERE  cost > avg_spent;