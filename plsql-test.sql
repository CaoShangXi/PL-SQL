-- 设置查询出来的数据表的长度为150字符长度
SET LINE 150;

-- 使用DBMS_OUTPUT软件包
set serveroutput on
-- 声明段
DECLARE
v_special_day VARCHAR2(200);
-- 执行段
BEGIN
v_special_day:=q'!Happy International Woman's Day on 8th March to all lovely women!';
DBMS_OUTPUT.PUT_LINE(v_special_day);
v_special_day:=q'[To many Chinese people,Qixi was celebrated as the "lovers' day".]';
DBMS_OUTPUT.PUT_LINE(v_special_day);
END;


DECLARE 
v_hiredate emp.hiredate %TYPE;
BEGIN
DSMS_OUTPUT.PUT_LINE(v_hiredate);
END;

DECLARE
true_love BOOLEAN:=TRUE;
BEGIN
true_love:=FALSE;
END;
-- 声明宿主变量
VARIABLE g_dog_weight NUMBER;
-- 初始化宿主变量
BEGIN
:g_dog_weight:=33;
END;



DECLARE
v_mumdog_sex CHAR(1):='F';
v_mumdog_weight NUMBER(5,2):=63;
BEGIN
DECLARE
v_babydog_sex CHAR(1):='M';
v_babydog_weight NUMBER(5,2):=3.8;
BEGIN
DBMS_OUTPUT.PUT_LINE(v_babydog_sex);
DBMS_OUTPUT.PUT_LINE(v_babydog_weight);
DBMS_OUTPUT.PUT_LINE(v_mumdog_sex);
DBMS_OUTPUT.PUT_LINE(v_mumdog_weight);
END;
DBMS_OUTPUT.PUT_LINE(v_mumdog_sex);
DBMS_OUTPUT.PUT_LINE(v_mumdog_weight);
END;
/

/*父子块变量同名的情况下，在PL/SQL的开始处增加BEGIN<<限定词>>和在结尾处增加END mumdog以达到在子程序块也能使用父块的变量*/
BEGIN<<mumdog>>
DECLARE
v_mumdog_sex CHAR(1):='F';
v_mumdog_weight NUMBER(5,2):=63;
BEGIN
DECLARE
v_mumdog_sex CHAR(1):='M';
v_mumdog_weight NUMBER(5,2):=3.8;
BEGIN
DBMS_OUTPUT.PUT_LINE(mumdog.v_mumdog_sex);
DBMS_OUTPUT.PUT_LINE(mumdog.v_mumdog_weight);
END;
DBMS_OUTPUT.PUT_LINE(v_mumdog_sex);
DBMS_OUTPUT.PUT_LINE(v_mumdog_weight);
END;
END mumdog;
/

<<mumdog>>
DECLARE
v_mumdog_sex CHAR(1):='F';
v_mumdog_weight NUMBER(5,2):=63;
BEGIN
DECLARE
v_mumdog_sex CHAR(1):='M';
v_mumdog_weight NUMBER(5,2):=3.8;
BEGIN
DBMS_OUTPUT.PUT_LINE(mumdog.v_mumdog_sex);
DBMS_OUTPUT.PUT_LINE(mumdog.v_mumdog_weight);
END;
DBMS_OUTPUT.PUT_LINE(v_mumdog_sex);
DBMS_OUTPUT.PUT_LINE(v_mumdog_weight);
END;
/

DECLARE
/*这个变量的数据类型就是dept表deptno字段的数据类型*/
v_deptno dept.deptno%TYPE;
v_loc VARCHAR(38);
BEGIN
SELECT deptno,loc
INTO v_deptno,v_loc
FROM dept
WHERE dname:='ACCOUNTING';
DBMS_OUTPUT.PUT_LINE('部门：'||v_deptno||',地址：'||v_loc);
END;
/

DECLARE
v_ename emp.ename%TYPE;
v_sal emp.sal%TYPE;
BEGIN
SELECT ename,sal
INTO v_ename,v_sal
FROM emp
WHERE job:='CLERK';
END;
/


SET serveroutput ON
SET verify OFF
DECLARE
v_sum_sal emp.sal%TYPE;
v_deptno NUMBER NOT NULL:=&p_department_id;
BEGIN
SELECT SUM(sal)
INTO v_sum_sal
FROM emp
WHERE deptno:=v_deptno;
DBMS_OUTPUT.PUT_LINE(v_deptno||'号部门的工资总和为：'||v_sum_sal);
END;
/


/*列出当前目录所有文件*/
host dir


/*变量名与列名相同*/
DECLARE
ename emp.ename%TYPE;
hiredate emp.hiredate%TYPE;
sal emp.sal%TYPE;
v_empno emp.empno%TYPE:=7788;
BEGIN
SELECT ename,hiredate,sal
INTO ename,hiredate,sal
FROM emp
WHERE empno:=v_empno;
END;
/

/*创建临时表*/
CREATE TABLE emp_pl
AS
SELECT * 
FROM emp;

CREATE TABLE dept_pl
AS
SELECT *
FROM dept;

/*创建序列*/
CREATE SEQUENCE deptid_sequence;

/*格式化列的宽度*/
col sequence_name for a18;

/*查看所有序列的详情*/
SELECT sequence_name,min_value,max_value,
increment_by,last_number
FROM user_sequences;

/*创建并初始化序列*/
CREATE SEQUENCE deptid_sequence
START WITH 50
INCREMENT BY 5
MAXVALUE 99
NOCACHE
NOCYCLE;

/*插入员工数据*/
BEGIN
INSERT INTO dept (deptno,dname,loc) VALUES (deptid_sequence.NEXTVAL,'公关部','公主坟');
END;
/*修改员工信息*/
SET verify OFF
DECLARE
v_sal_increase emp.sal%TYPE:=&p_salary_increase;
BEGIN
UPDATE emp
SET sal:=sal-v_sal_increase
WHERE job:='CLERK';
END;

SELECT empno,ename,job,sal
FROM emp
WHERE job:='CLERK';

/*演示出现两个替代变量的时候*/
SET verify OFF
DECLARE
v_job emp_pl.job%TYPE:='&p_job';
v_sal emp_pl.sal%TYPE:=&sal;
BEGIN
DELETE FROM emp_pl
WHERE job:=v_job
AND sal>v_sal;
END;
/

/*从旧表复制数据到新表*/
CREATE TABLE copy_emp as
SELECT * FROM emp
WHERE deptno:=20;

/*有条件的对数据表进行操作*/
BEGIN
MERGE INTO copy_emp c
USING emp e
ON (c.empno:=e.empno)
WHEN MATCHED THEN
UPDATE SET 
/*c.empno:=e.empno,ON条件中的列是不能更新的*/
c.ename:=e.ename,
c.job:=e.job,
c.mgr:=e.mgr,
c.hiredate:=e.hiredate,
c.sal:=e.sal,
c.comm:=e.comm,
c.deptno:=e.deptno
WHEN NOT MATCHED THEN
INSERT VALUES(e.empno,e.ename,e.job,e.mgr,
e.hiredate,e.sal,e.comm,e.deptno);
END;
/


/*将当前回话的日期语言改为美国英语*/
alter session set NLS_DATE_LANGUAGE:='AMERICAM';

/*IF语句的使用*/
SET verify OFF
SET serveroutput ON
DECLARE
v_age number:=&p_age;
BEGIN
IF v_age<60 -- 如果v_age小于60就使用DBMS_OUTPUT软件包列出相关信息
THEN
DBMS_OUTPUT.PUT_LINE('您不到退休年龄，还必须继续工作为革命事业在做些贡献！！！');
END IF;
END;
/

SET verify OFF
SET serveroutput ON
DECLARE
v_age number:=&p_age;
v_gender CHAR(1):='&p_sex';
BEGIN
IF(v_age BETWEEN 18 AND 35) AND (v_gender:='F')
THEN
DBMS_OUTPUT.PUT_LINE('这位靓女可能成为老板的下一任秘书！！！');
END IF;
END;
/

/*IF-THEN-ELSE的使用*/
SET verify OFF;
SET serveroutput ON;
DECLARE
v_shipdate DATE:='&p_shipdate';
v_orderdate DATE:='&p_orderdate';
v_ship_flag VARCHAR(16);
BEGIN
IF v_shipdate-v_orderdate<8 THEN
v_ship_flag:='Acceptable';
DBMS_OUTPUT.PUT_LINE('该公司的服务不错：');
ELSE
v_ship_flag:='Unacceptable';
DBMS_OUTPUT.PUT_LINE('该公司的服务太差了：');
END IF;
DBMS_OUTPUT.PUT_LINE(v_ship_flag);
END;
/

/*IF-THEN-ELSIF*/
SET verify OFF
SET serveroutput ON
DECLARE
v_age NUMBER:=&p_age;
BEGIN
IF v_age<60 THEN
DBMS_OUTPUT.PUT_LINE('您不到退休年龄，还必须继续工作为革命事业在做些贡献！！！');
ELSIF v_age<65 THEN
DBMS_OUTPUT.PUT_LINE('您可以退休了，并且可以半价进入一般的公园！！！');
ELSIF v_age<80 THEN
DBMS_OUTPUT.PUT_LINE('您现在可以免费进公园免费坐公交车了！！！');
ELSIF v_age<90 THEN
DBMS_OUTPUT.PUT_LINE('您现在可以享受每月100元的老年补贴了！！！');
ELSIF v_age<100 THEN
DBMS_OUTPUT.PUT_LINE('您现在可以享受每月200元的老年补贴了！！！');
ELSE
DBMS_OUTPUT.PUT_LINE('您现在可以可以免费玩过山车和蹦极了！！！');
END IF;
END;
/

/*演示使用CASE语句*/
SET verify OFF;
SET serveroutput ON;
DECLARE 
v_degree CHAR(1):=UPPER('&p_degree');
v_description VARCHAR2(250);
BEGIN
v_description:=CASE v_degree
WHEN 'B' THEN '此人拥有学士学位。'
WHEN 'M' THEN '此人拥有硕士学位。'
WHEN 'D' THEN '此人拥有博士学位。'
ELSE '此人拥有壮士学位。'
END;
DBMS_OUTPUT.PUT_LINE(v_description);
END;
/

/*演示使用搜索CASE*/
SET verify OFF;
SET serveroutput ON;
DECLARE
v_degree CHAR(1):=UPPER('&p_degree');
v_description VARCHAR(250);
BEGIN
CASE
WHEN v_degree:='B' THEN 
DBMS_OUTPUT.PUT_LINE('此人拥有学士学位。');
WHEN v_degree:='M' THEN 
DBMS_OUTPUT.PUT_LINE('此人拥有硕士学位。');
WHEN v_degree:='D' THEN 
DBMS_OUTPUT.PUT_LINE('此人拥有博士学位。');
WHEN v_degree:='X' THEN
DBMS_OUTPUT.PUT_LINE('此人拥有壮士学位。');
END CASE;
END;
/


SET verify OFF
SET serveroutput ON
DECLARE
v_empno NUMBER:=&p_empno;
v_ename VARCHAR(30);
v_job emp.job%TYPE;
v_sal emp.sal%TYPE;
BEGIN
SELECT job INTO v_job FROM emp WHERE empno:=v_empno;
CASE v_job
WHEN 'SALESMAN' THEN
SELECT empno,ename,job,sal*1.15 INTO v_empno,v_ename,v_job,v_sal
FROM emp
WHERE empno:=v_empno;
DBMS_OUTPUT.PUT_LINE(v_job||' '||v_ename||'加薪后的工资为：'||v_sal); 
WHEN 'CLERK' THEN
SELECT empno,ename,job,sal*1.20 INTO v_empno,v_ename,v_job,v_sal
FROM emp
WHERE empno:=v_empno;
DBMS_OUTPUT.PUT_LINE(v_job||' '||v_ename||'加薪后的工资为：'||v_sal);
WHEN 'ANIALYST' THEN
SELECT empno,ename,job,sal*1.25 INTO v_empno,v_ename,v_job,v_sal
FROM emp
WHERE empno:=v_empno;
DBMS_OUTPUT.PUT_LINE(v_job||' '||v_ename||'加薪后的工资为：'||v_sal);
WHEN 'MANAGER' THEN
SELECT empno,ename,job,sal*1.30 INTO v_empno,v_ename,v_job,v_sal
FROM emp
WHERE empno:=v_empno;
DBMS_OUTPUT.PUT_LINE(v_job||' '||v_ename||'加薪后的工资为：'||v_sal);
END CASE;
END;
/

/*GOTO语句的使用*/
SET verify OFF
SET serveroutput ON
DECLARE
v_num NUMBER:=&p_num;
v_count NUMBER:=0;
BEGIN<<loop_start>> --loop_start语句
IF v_count:=0 THEN
DBMS_OUTPUT.PUT_LINE('这个数为：0。');
ELSIF v_count<2 THEN
DBMS_OUTPUT.PUT_LINE(v_count||'小于等于2');
ELSIF v_count MOD 2<>0 THEN
DBMS_OUTPUT.PUT_LINE(v_count||'这个数是奇数。');
ELSe
DBMS_OUTPUT.PUT_LINE(v_count||'这个数是偶数。');
END IF;
v_count:=v_count+1;
IF v_count<:=v_num THEN
GOTO loop_start; --返回loop_start语句
END IF;
END;
/
END;


select 7+null from dual;




/*基本循环*/
SET verify OFF
DECLARE
v_empno emp_pl.empno%TYPE;
v_deptno emp_pl.deptno%TYPE:=&p_deptno;
v_sal emp_pl.sal%TYPE:=&p_sal;
v_hiredate emp_pl.hiredate%TYPE:=sysdate;
v_job emp_pl.job%TYPE:='&p_job';
v_counter NUMBER(2):=1;
v_max_num NUMBER(2):=&p_max_num;
BEGIN
SELECT MAX(empno) INTO v_empno FROM emp_pl;
LOOP
INSERT INTO emp_pl(empno,hiredate,job,sal,deptno) VALUES (v_empno+v_counter,v_hiredate,v_job,v_sal,v_deptno);
v_counter:=v_counter+1;
EXIT WHEN v_counter>v_max_num;
END LOOP;
END;
/

/*WHILE循环*/
SET verify OFF
DECLARE
v_deptno dept.deptno%TYPE;
v_loc dept.loc%TYPE:='&p_loc';
v_counter NUMBER(2):=1;
v_max_num NUMBER(2):=&p_max_num;
BEGIN
WHILE v_counter<:=v_max_num LOOP
INSERT INTO dept_pl (deptno,loc) values (deptid_sequence.NEXTVAL,v_loc);
v_counter:=v_counter+1;
END LOOP;
END;
/

SET verify OFF
DECLARE
v_empno emp_pl.empno%TYPE;
v_deptno emp_pl.deptno%TYPE:=&p_deptno;
v_sal emp_pl.sal%TYPE:=&p_sal;
v_hiredate emp_pl.hiredate%TYPE:=sysdate;
v_job emp_pl.job%TYPE:='&p_job';
v_counter NUMBER(2):=1;
v_max_num NUMBER(2):=&p_max_num;
BEGIN
SELECT MAX(empno) INTO v_empno FROM emp_pl;
WHILE v_counter<:=v_max_num LOOP
INSERT INTO emp_pl(empno,hiredate,job,sal,deptno) VALUES (v_empno+v_counter,v_hiredate,v_job,v_sal,v_deptno);
v_counter:=v_counter+1;
END LOOP;
END;
/


/*复制表的结构*/
CREATE TABLE ex_emp
AS
SELECT *
FROM emp
WHERE 1:=2;
/*添加字段*/
ALTER TABLE ex_emp ADD (leavedate DATE);

/*使用%ROWTYPE属性声明PL/SQL变量*/
SET verify OFF
DECLARE
emp_rec emp%ROWTYPE;
BEGIN
SELECT * INTO emp_rec
FROM emp
WHERE empno:=&employee_number;
INSERT INTO ex_emp (empno,ename,job,mgr,hiredate,sal,comm,deptno,leavedate) 
VALUES
(emp_rec.empno,emp_rec.ename,emp_rec.job,emp_rec.mgr,emp_rec.hiredate,emp_rec.sal,emp_rec.comm,emp_rec.deptno,sysdate);
COMMIT;
END;

SET verify OFF
DECLARE
v_emp_rec ex_emp%ROWTYPE;
BEGIN
SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno,hiredate INTO
v_emp_rec
FROM emp
WHERE empno:=&p_empno;
INSERT INTO ex_emp VALUES v_emp_rec;-- 将记录变量的值插入到ex_emp表
END;
/

SET verify OFF
DECLARE
v_emp_rec ex_emp%ROWTYPE;
BEGIN
SELECT * INTO v_emp_rec
FROM ex_emp 
WHERE empno:=&p_empno;
v_emp_rec.leavedate:=CURRENT_DATE;
UPDATE ex_emp
SET ROW:=v_emp_rec-- 更新指定的记录
WHERE empno:=v_emp_rec.empno;
END;
/


/*使用INDEX BY表（即数组）*/
SET verify OFF
SET serveroutput ON
DECLARE
-- 声明一个数组
TYPE ename_table_type IS TABLE OF
emp.ename%TYPE-- 数据类型为emp.ename字段的数据类型
INDEX BY PLS_INTEGER;-- 数组索引的数据类型
-- 声明一个数组
TYPE hiredate_table_type IS TABLE OF
emp.hiredate%TYPE-- 数据类型为emp.hiredate字段的数据类型
INDEX BY PLS_INTEGER;-- 数组索引的数据类型
ename_table ename_table_type;-- 数组赋给变量
hiredate_table hiredate_table_type;-- 数组赋给变量
v_count NUMBER(6):=&p_count;
BEGIN
FOR i IN 1..v_count LOOP
ename_table(i):='武大';
hiredate_table(i):=sysdate+14;
DBMS_OUTPUT.PUT_LINE(ename_table(i)||'  '||hiredate_table(i));
END LOOP;
END;
/

/*INDEX BY表的索引可以是负数也可以不连续*/
SET verify OFF
SET serveroutput ON
DECLARE
TYPE ename_table_type IS TABLE OF
emp.ename%TYPE
INDEX BY PLS_INTEGER;
TYPE hiredate_table_type IS TABLE OF
emp.hiredate%TYPE
INDEX BY PLS_INTEGER;
ename_table ename_table_type;
hiredate_table hiredate_table_type;
BEGIN
ename_table(-8):='武大';
hiredate_table(-8):=sysdate+14;
DBMS_OUTPUT.PUT_LINE(ename_table(-8)||'  '||hiredate_table(-8));
END;
/

/*INDEX BY表里面的索引需要为其赋初始值*/
SET verify OFF
SET serveroutput ON
DECLARE
TYPE ename_table_type IS TABLE OF
emp.ename%TYPE
INDEX BY PLS_INTEGER;
TYPE hiredate_table_type IS TABLE OF
emp.hiredate%TYPE
INDEX BY PLS_INTEGER;
ename_table ename_table_type;
hiredate_table hiredate_table_type;
BEGIN
ename_table(-8):='武大';
hiredate_table(-8):=sysdate+14;
DBMS_OUTPUT.PUT_LINE(ename_table(-8)||'  '||hiredate_table(-8));
DBMS_OUTPUT.PUT_LINE(ename_table(-7)||' '||hiredate_table(-7));
END;
/

/*INDEX BY表的函数*/
SET verify OFF
SET serveroutput ON
DECLARE
TYPE emp_num_type IS TABLE OF NUMBER -- INDEX BY表中的数据类型为NUMBER
INDEX BY VARCHAR2(38); -- 索引是变长字符串类型
Total_employees emp_num_type;
i VARCHAR2(38);
BEGIN
SELECT count(*) INTO Total_employees('ACCOUNTING')
FROM emp WHERE deptno:=10;
SELECT count(*) INTO Total_employees('RESEARCH')
FROM emp WHERE deptno:=20;
SELECT count(*) INTO Total_employees('SALES')
FROM emp WHERE deptno:=30;
i:=Total_employees.FIRST;-- INDEX BY表里面最开始的那个元素
DBMS_OUTPUT.PUT_LINE('按升序列出每个部门名和员工总数：');
WHILE i IS NOT NULL LOOP
DBMS_OUTPUT.PUT_LINE('Total number of employees in '|| i||' is '||TO_CHAR(Total_employees(i)));
i:=Total_employees.NEXT(i);-- 返回当前元素下一个元素的下标
END LOOP;
DBMS_OUTPUT.PUT_LINE(CHR(10));
i:=Total_employees.LAST;-- INDEX BY表里面最后一个元素的下标
WHILE i IS NOT NULL LOOP
DBMS_OUTPUT.PUT_LINE('Total number of employees in '|| i||' is '||TO_CHAR(Total_employees(i)));
i:=Total_employees.PRIOR(i);-- 返回当前元素上一个元素的下标
END LOOP;
DBMS_OUTPUT.PUT_LINE('INDEX BY表里面的元素个数为：'||Total_employees.count);
/*Total_employees.DELETE;-- 删除INDEX BY表里面的所有元素
DBMS_OUTPUT.PUT_LINE('INDEX BY表里面的元素个数为：'||Total_employees.count);*/
/*Total_employees.DELETE('SALES');
DBMS_OUTPUT.PUT_LINE('INDEX BY表里面的元素个数为：'||Total_employees.count);*/
Total_employees.DELETE('ACCOUNTING','SALES');
DBMS_OUTPUT.PUT_LINE('INDEX BY表里面的元素个数为：'||Total_employees.count);
END;
/

INSERT INTO dept_pl (deptno,dname,loc) VALUES (50,'保卫部','将军堡');
COMMIT;
/*INDEX BY记录表的使用*/
SET verify OFF
SET serveroutput ON
DECLARE
TYPE dept_table_type IS TABLE OF dept_pl%ROWTYPE
INDEX BY PLS_INTEGER;
dept_table dept_table_type;
v_count NUMBER(3):=5;
v_j NUMBER(3);
BEGIN
FOR i IN 1..v_count LOOP
SELECT * INTO dept_table(i*10)
FROM dept_pl
WHERE deptno=i*10;
END LOOP;
v_j:=dept_table.FIRST;
WHILE v_j IS NOT NULL LOOP
DBMS_OUTPUT.PUT_LINE(dept_table(v_j).deptno||'  '||dept_table(v_j).dname||'  '||dept_table(v_j).loc);
v_j:=dept_table.NEXT(v_j);
END LOOP;
END;
/


/*隐式cursor 的SQL%ROWCOUNT的使用
SQL%ROWCOUNT:返回刚刚执行过的SQL语句所影响的数据行数
*/
SET verify OFF
SET serveroutput ON
DECLARE
v_rows_updated VARCHAR2(38);
v_deptno emp_pl.deptno%TYPE:=&p_deptno;
BEGIN
UPDATE emp_pl
SET sal:=9999
WHERE deptno:=v_deptno;
v_rows_updated:=(SQL%ROWCOUNT||'行数据已经被修改了。');
DBMS_OUTPUT.PUT_LINE(v_rows_updated);
END;
/

/*显式cursor的使用*/
DECLARE
v_empno emp.empno%TYPE;
v_ename emp.ename%TYPE;
v_job emp.job%TYPE;
v_sal emp.sal%TYPE;
-- 创建cursor
CURSOR emp_cursor IS
SELECT empno,ename,job,sal
FROM emp
WHERE deptno:=20
ORDER BY sal;

v_deptno dept.deptno%TYPE;
v_danme dept.dname%TYPE;
v_loc dept.loc%TYPE;
-- 创建cursor
CURSOR dept_cursor IS
SELECT * FROM dept
ORDER BY loc;

DECLARE
v_empno emp.empno%TYPE;
v_ename emp.ename%TYPE;
v_job emp.job%TYPE;
v_sal emp.sal%TYPE;
-- 创建cursor
CURSOR emp_cursor IS
SELECT empno,ename,job,sal
FROM emp
WHERE empno:=7900;
BEGIN
OPEN emp_cursor;
FETCH emp_cursor INTO v_empno,v_ename,v_job,v_sal;
DBMS_OUTPUT.PUT_LINE(v_empno||' '||v_ename||'  '||v_job||'  '||v_sal);
END;
/

SET verify OFF
SET serveroutput ON
DECLARE
v_empno emp.empno%TYPE;
v_ename emp.ename%TYPE;
v_job emp.job%TYPE;
v_sal emp.sal%TYPE;
-- 创建cursor
CURSOR emp_cursor IS
SELECT empno,ename,job,sal
FROM emp
WHERE deptno:=20;
BEGIN
OPEN emp_cursor;
FETCH emp_cursor INTO v_empno,v_ename,v_job,v_sal;
DBMS_OUTPUT.PUT_LINE(v_empno||' '||v_ename||'  '||v_job||'  '||v_sal);
END;
/

/*关闭显式cursor及使用它的属性*/
CLOSE emp_cursor;

/*利用循环及属性控制cursor*/
SET verify OFF
SET serveroutput ON
DECLARE
v_empno emp.empno%TYPE;
v_ename emp.ename%TYPE;
v_job emp.job%TYPE;
v_sal emp.sal%TYPE;
-- 创建cursor
CURSOR emp_cursor IS
SELECT empno,ename,job,sal
FROM emp
ORDER BY sal;
BEGIN
-- 打开cursor
OPEN emp_cursor;
LOOP
FETCH emp_cursor INTO v_empno,v_ename,v_job,v_sal;
EXIT WHEN emp_cursor%ROWCOUNT>100 or emp_cursor%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_empno||' '||v_ename||'  '||v_job||'  '||v_sal);
END LOOP;
-- 关闭cursor
CLOSE emp_cursor;
END;
/

SET verify OFF
SET serveroutput ON
DECLARE
v_empno emp.empno%TYPE;
v_ename emp.ename%TYPE;
v_job emp.job%TYPE;
v_sal emp.sal%TYPE;
-- 创建cursor
CURSOR emp_cursor IS
SELECT empno,ename,job,sal
FROM emp
ORDER BY sal;
BEGIN
-- 打开cursor
OPEN emp_cursor;
LOOP
FETCH emp_cursor INTO v_empno,v_ename,v_job,v_sal;
-- 如果FETCH语句没执行成功过%NOTFOUND属性就会返回NULL值，所以为了保险还要判断返回得值是否是NULL。
EXIT WHEN emp_cursor%ROWCOUNT>100 or emp_cursor%NOTFOUND or emp_cursor%NOTFOUND IS NULL;
DBMS_OUTPUT.PUT_LINE(v_empno||' '||v_ename||'  '||v_job||'  '||v_sal);
END LOOP;
-- 关闭cursor
CLOSE emp_cursor;
END;
/

/*综合知识运用*/
SET verify OFF
DECLARE
-- 创建cursor
CURSOR emp_cursor IS
SELECT *
FROM emp;
-- 将emp_cursor的字段类型赋给emp_record
emp_record emp_cursor%ROWTYPE;
-- 创建8集合(INDEX BY记录表)
TYPE emp_table_type IS TABLE OF
emp%ROWTYPE INDEX BY PLS_INTEGER;
v_emp_record emp_table_type;
n NUMBER(3):=1;
BEGIN
OPEN emp_cursor;
LOOP
FETCH emp_cursor INTO emp_record;
EXIT WHEN emp_cursor%NOTFOUND;
v_emp_record(n):=emp_record;
n:=n+1;
END LOOP;
CLOSE emp_cursor;
<<Outer_loop>>
FOR i IN v_emp_record.FIRST..v_emp_record.LAST LOOP
FOR j IN v_emp_record.FIRST..v_emp_record.LAST LOOP
IF v_emp_record(i).empno:=v_emp_record(j).mgr THEN
DBMS_OUTPUT.PUT_LINE(v_emp_record(i).job||'  '||v_emp_record(i).ename||'  是真正的经理，不是光杆司令！！！');
CONTINUE Outer_loop;-- 跳出到外循环
END IF;
END LOOP;-- 结束内循环
END LOOP Outer_loop;-- 结束外循环
END;
/

/*Cursor的for循环*/
SET verify OFF
SET serveroutput ON
DECLARE
CURSOR emp_cursor IS
SELECT *
FROM emp;
BEGIN
FOR emp_record IN emp_cursor LOOP
-- 隐含打开cursor并提取数据行
IF emp_record.deptno:=20 THEN
DBMS_OUTPUT.PUT_LINE(emp_record.job||'  '||emp_record.ename||' 在研发部工作！！！');
END IF;
END LOOP;-- 隐含关闭cursor
END;
/ 

/*在cursor的FOR循环中使用子查询*/
SET verify OFF
SET serveroutput ON
BEGIN              -- 子查询在这
FOR emp_record IN (SELECT * FROM emp) LOOP
-- 隐含打开cursor并提取数据行
IF emp_record.deptno:=20 THEN
DBMS_OUTPUT.PUT_LINE(emp_record.job||'  '||emp_record.ename||' 在研发部工作！！！');
END IF;
END LOOP;-- 隐含关闭cursor
END;
/ 

SET verify OFF
SET serveroutput ON
DECLARE
CURSOR dept_cursor_total IS
SELECT d.deptno,d.dname, av_salary,e.min_salary,e.max_salary,e.emp_total
FROM dept d,(
SELECT deptno,ROUND(avg(sal),2) av_salary,min(sal) min_salary,max(sal) max_salary,count(*) emp_total
FROM emp 
GROUP BY deptno
)e WHERE d.deptno:=e.deptno AND e.av_salary>2000 ORDER BY d.deptno;
BEGIN
FOR dept_record IN dept_cursor_total LOOP
DBMS_OUTPUT.PUT_LINE(dept_record.deptno||'  '||dept_record.dname||'  '||dept_record.av_salary||'  '||dept_record.min_salary||'  '||dept_record.max_salary||'  '||dept_record.emp_total );
END LOOP;
END;
/

/*带参数的cursor*/
SET verify OFF
SET serveroutput ON
DECLARE
CURSOR emp_cursor (p_deptno NUMBER,p_job VARCHAR2) IS
SELECT * 
FROM emp_pl
WHERE deptno:=p_deptno
AND job:=p_job;
emp_record emp_pl%ROWTYPE;-- 声明一个记录变量
BEGIN
/*原始版cursor*/
OPEN emp_cursor(20,'ANALYST');-- 获得结果集，并把指针指向结果集的第一条记录
LOOP
FETCH emp_cursor INTO emp_record;-- 将结果集的记录赋值给记录变量，并将指针移到下一条记录
DBMS_OUTPUT.PUT_LINE(emp_record.empno||'  '||
                     emp_record.ename||'  '||
					 emp_record.job||'  '||
					 emp_record.mgr||'  '||
					 emp_record.hiredate||'  '||
					 emp_record.sal||'  '||
					 emp_record.comm||'  '||
					 emp_record.deptno);
EXIT WHEN emp_cursor%NOTFOUND OR emp_cursor%NOTFOUND IS NULL;-- 当满足条件时退出循环
END LOOP;
CLOSE emp_cursor;-- 关闭cursor
/*FOR循环版cursor*/
FOR emp_record IN emp_cursor(10,'CLERK') LOOP
DBMS_OUTPUT.PUT_LINE(emp_record.empno||'  '||
                     emp_record.ename||'  '||
					 emp_record.job||'  '||
					 emp_record.mgr||'  '||
					 emp_record.hiredate||'  '||
					 emp_record.sal||'  '||
					 emp_record.comm||'  '||
					 emp_record.deptno);
END LOOP;
END;
/

/*使用FOR循环插入数据*/
DECLARE
emp_record emp_pl%ROWTYPE;
BEGIN
emp_record.empno:=7935;
emp_record.ename:='张三';
emp_record.job:='保安';
emp_record.hiredate:=sysdate;
emp_record.sal:=9999;
emp_record.comm:=200;
emp_record.deptno:=70;
FOR i IN 1..5 LOOP
INSERT INTO emp_pl(empno,ename,job,hiredate,sal,comm,deptno) VALUES 
(emp_record.empno+i,emp_record.ename,emp_record.job,emp_record.hiredate,emp_record.sal,emp_record.comm,emp_record.deptno);
END LOOP;
COMMIT;
END;
/

/*FOR UPDATE OF:锁住相关的数据行*/
DECLARE
CURSOR emp_cursor IS
SELECT * FROM emp_pl
WHERE deptno=70
FOR UPDATE OF sal NOWAIT;-- 锁住数据行
BEGIN
OPEN emp_cursor;
END;
/

/*WHERE CURRENT OF:对cursor锁住的记录进行DML操作*/
DECLARE
CURSOR emp_cursor IS
SELECT * FROM emp_pl
WHERE deptno=70
FOR UPDATE OF sal NOWAIT;-- 锁住数据行
BEGIN
FOR emp_record IN emp_cursor LOOP
UPDATE emp_pl SET
sal=emp_record.sal*0.15
WHERE CURRENT OF emp_cursor;
END LOOP;
COMMIT;
END;
/

/*异常的使用*/

/*模拟异常*/
SET verify OFF
SET serveroutput ON
DECLARE
v_job emp_pl.job%TYPE:='保安';
BEGIN
SELECT job INTO v_job
FROM emp_pl
WHERE job=v_job;
DBMS_OUTPUT.PUT_LINE(v_job);
END;
/

/*捕捉异常*/
SET verify OFF
SET serveroutput ON
DECLARE
v_job emp_pl.job%TYPE:='&p_job';
BEGIN
SELECT job INTO v_job
FROM emp_pl
WHERE job=v_job;
DBMS_OUTPUT.PUT_LINE(v_job);
EXCEPTION-- 异常关键字
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE('该查询语句提供了多行数据，可使用cursor来解决这一问题！');
END;
/

/*非预定义异常的使用*/
SET verify OFF;
SET serveroutput ON;
DECLARE
e_emps_remaining EXCEPTION;-- 声明一个非预定义异常
PRAGMA EXCEPTION_INIT (e_emps_remaining,-2292);-- 错误代码与非预定义异常关联
v_deptno dept.deptno%TYPE:=&p_deptno;
BEGIN
DELETE FROM dept
WHERE deptno=v_deptno;
COMMIT;
EXCEPTION
WHEN e_emps_remaining THEN-- 异常条件
DBMS_OUTPUT.PUT_LINE('无法删除这个部门-部门'||TO_CHAR(v_deptno)||',因为这个部门还有员工！');
END;
/

/*模拟错误的DML操作，获取错误代码*/
INSERT INTO emp(empno,ename,job,sal,deptno) 
VALUES (3838,'童铁蛋','保安',1250,38);
/*根据错误代码捕捉异常*/
DECLARE
e_emps_remaining EXCEPTION;
PRAGMA EXCEPTION_INIT(e_emps_remaining,-02291);
v_deptno dept.deptno%TYPE:=&p_deptno;
BEGIN
INSERT INTO emp(empno,ename,job,sal,deptno) 
VALUES (3838,'童铁蛋','保安',1250,v_deptno);
EXCEPTION
WHEN e_emps_remaining THEN
DBMS_OUTPUT.PUT_LINE(v_deptno||' 部门根本不存在！');
DBMS_OUTPUT.PUT_LINE(SQLERRM);-- 输出错误信息
END;
/

/*建数据表，保存异常信息*/
CREATE TABLE errors(
user_name VARCHAR2(255),
error_date DATE,
error_code NUMBER(10),
error_message VARCHAR2(255)
);

/*捕获异常的两个函数，SQLCODE、SQLERRM*/
SET verify OFF;
SET serveroutput ON;
DECLARE
v_empno emp.empno%TYPE:=&p_empno;
v_deptno emp.deptno%TYPE:=&p_deptno;
v_error_code NUMBER;
v_error_message VARCHAR2(255);
BEGIN
INSERT INTO emp(empno,ename,job,sal,deptno) VALUES (v_empno,'童铁蛋','保安',1250,v_deptno);
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
v_error_code:=SQLCODE;
v_error_message:=SQLERRM;
INSERT INTO errors(user_name,error_date,error_code,error_message)
VALUES
(USER,SYSDATE,v_error_code,v_error_message);
COMMIT;
END;
/
 SELECT error_code,count(*) FROM errors GROUP BY error_code;
 UPDATE emp_pl
 SET job='九九'
 WHERE empno=1235
 ;
 
 
/*自定义异常的使用*/
SET verify OFF;
SET serveroutput ON;
DECLARE
e_invalid_employee EXCEPTION;-- 自定义异常
BEGIN
UPDATE emp_pl
SET job='&p_job'
WHERE empno=&p_empno;
IF SQL%NOTFOUND THEN-- 判断是否有数据返回
RAISE e_invalid_employee;-- 抛出异常
END IF;
COMMIT;
EXCEPTION
WHEN e_invalid_employee THEN--捕获自定义异常
DBMS_OUTPUT.PUT_LINE('该员工不存在，因为这是一个无效的员工号。');
END;
/

/*RAISE_APPLICATION_ERROR过程的使用，让抛出的异常像Oracle预定义的异常一样*/
SET verify OFF;
SET serveroutput ON;
BEGIN
DELETE FROM emp_pl
WHERE ename='&p_ename';
IF SQL%NOTFOUND THEN
RAISE_APPLICATION_ERROR(-20077,'公司并没有雇佣这一员工！');
END IF;
END;
/

SET verify OFF;
SET serveroutput ON;
DECLARE
e_invalid_employee EXCEPTION;
PRAGMA EXCEPTION_INIT(e_invalid_employee,-20077);
BEGIN
DELETE FROM emp_pl
WHERE ename='&p_ename';
IF SQL%NOTFOUND THEN
RAISE e_invalid_employee;
END IF;
COMMIT;
EXCEPTION
WHEN e_invalid_employee THEN
RAISE_APPLICATION_ERROR(-20077,'公司并没有雇佣这一员工！');
END;
/

SELECT * FROM emp_pl;
/*PL/SQL 过程的应用*/
CREATE OR REPLACE PROCEDURE raise_salary
(p_empno IN emp_pl.empno%TYPE,-- 以IN的模式给过程传递参数
 p_rate IN NUMBER)
 IS
 BEGIN
 UPDATE emp_pl
 SET sal=sal*(1+p_rate*0.01)
 WHERE empno=p_empno;
 END raise_salary;-- 结束过程
 /
 /*执行过程*/
 EXECUTE raise_salary(7369,20);
 /*降薪10%*/
 EXECUTE raise_salary(7369,-10);
 
 /*OUT参数的使用，OUT关键字能将参数返回给调用环境*/
 /*1.创建过程*/
 CREATE OR REPLACE PROCEDURE get_employee
 (p_empno IN emp.empno%TYPE,-- IN参数
 p_ename OUT emp.ename%TYPE,-- OUT参数
 p_salary OUT emp.sal%TYPE,
 p_job OUT emp.job%TYPE)
 IS
 BEGIN
 SELECT ename,sal,job
 INTO p_ename,p_salary,p_job
 FROM emp
 WHERE empno=p_empno;
 END get_employee;
 /
 /*2.使用过程*/ 
 SET verify OFF;
 SET serveroutput ON;
 DECLARE
 v_ename emp.ename%TYPE;
 v_sal emp.sal%TYPE;
 v_job emp.job%TYPE;
 BEGIN
 get_employee(7788,v_ename,v_sal,v_job);-- 调用过程
 DBMS_OUTPUT.PUT_LINE(v_job||' '||v_ename||'工资为：'||TO_CHAR(v_sal,'L99,999.00'));
 END;
 /
 
 /*IN OUT参数模式的使用*/
 CREATE OR REPLACE PROCEDURE standard_phone
 (p_phone_no IN OUT VARCHAR2) IS
 BEGIN
 p_phone_no:='('||SUBSTR(p_phone_no,1,3)||')'||SUBSTR(p_phone_no,4,3)||'-'||SUBSTR(p_phone_no,7);
 END standard_phone;
 /
 
 VARIABLE g_phone_no VARCHAR2(20)
EXECUTE :g_phone_no:='800449444'
PRINT g_phone_no
EXECUTE standard_phone(:g_phone_no)
PRINT g_phone_no

/*删除数据*/
DELETE dept_pl
WHERE deptno=40;
/*删除序列*/
DROP SEQUENCE deptid_sequence;
/*创建序列*/
CREATE SEQUENCE deptid_sequence
START WITH 50
INCREMENT BY 5
MAXVALUE 1000
NOCACHE
NOCYCLE;
/*创建过程*/
CREATE OR REPLACE PROCEDURE add_dept
(v_name IN dept_pl.dname%TYPE DEFAULT '服务',-- 为IN参数模式设置默认值
 v_loc IN dept_pl.loc%TYPE DEFAULT '狼山镇') -- 为IN参数模式设置默认值
 IS
 BEGIN
 INSERT INTO dept_pl VALUES(deptid_sequence.NEXTVAL,v_name,v_loc);
 END add_dept;
 /
 /*执行过程*/
 BEGIN
 -- 参数传递表示法，让形参和实参灵活绑定
 add_dept;
 add_dept('公关','公主坟');
 add_dept(v_loc=>'将军堡',v_name=>'保卫');-- 将形参和实参关联起来
 add_dept(v_loc=>'驴市');
 END;
 /
 
/*在PL/SQL程序中调用过程*/
SET verify OFF;
SET serveroutput ON;
DECLARE
v_deptno emp_pl.deptno%TYPE:=&p_deptno;
v_salary NUMBER(8,2):=&p_salary;
CURSOR emp_cursor IS
SELECT empno
FROM emp_pl
WHERE deptno=v_deptno;
BEGIN
FOR emp_record IN emp_cursor LOOP
raise_salary(emp_record.empno,v_salary);
END LOOP;
COMMIT;
END;
/

/*在过程中调用过程*/
-- 1.创建数据表
CREATE TABLE log_table(
user_id VARCHAR2(38),
log_date DATE,
empno NUMBER(8)
);
-- 2.创建过程调用过程
CREATE OR REPLACE PROCEDURE audit_emp_pl(
p_id IN emp_pl.empno%TYPE)
IS
PROCEDURE log_exec -- 在过程中声明一个过程
IS
BEGIN
INSERT INTO log_table(user_id,log_date,empno) VALUES (USER,SYSDATE,p_id);
END log_exec;-- 结束过程的声明
BEGIN
DELETE FROM emp_pl
WHERE empno=p_id;
log_exec;
END audit_emp_pl;
/
-- 3.执行过程
EXEC audit_emp_pl(7939);

/*在过程中处理异常*/
-- 修改表结构供后续测试
ALTER TABLE dept_pl
ADD CONSTRAINT deptpl_dname_uk UNIQUE(dname);
-- 创建过程
SET serveroutput ON;
CREATE OR REPLACE PROCEDURE add_depte
(p_name IN dept_pl.dname%TYPE DEFAULT '服务',
 p_loc IN dept_pl.loc%TYPE DEFAULT '狼山镇'
)
IS
BEGIN
INSERT INTO dept_pl
VALUES (deptid_sequence.NEXTVAL,p_name,p_loc);
DBMS_OUTPUT.PUT_LINE('部门：'||p_name);
EXCEPTION
WHEN others THEN
DBMS_OUTPUT.PUT_LINE('错误，添加了重复的部门:'||p_name);
END add_depte;
/
-- 过程中调用带异常的过程
CREATE OR REPLACE PROCEDURE create_depts IS
BEGIN
add_depte;
add_depte;
add_depte('技术','中关村');
END create_depts;
/
/*执行过程*/
EXEC create_depts;

/*如果被调用的过程里面没有异常段，那么出现异常时异常会自动抛给调用环境，所做的DML操作也会事务回滚*/
-- 创建没有异常段的过程
SET serveroutput ON;
CREATE OR REPLACE PROCEDURE add_depte
(p_name IN dept_pl.dname%TYPE DEFAULT '服务',
 p_loc IN dept_pl.loc%TYPE DEFAULT '狼山镇'
)
IS
BEGIN
INSERT INTO dept_pl
VALUES (deptid_sequence.NEXTVAL,p_name,p_loc);
DBMS_OUTPUT.PUT_LINE('部门：'||p_name);
END add_depte;
/
-- 调用过程
CREATE OR REPLACE PROCEDURE create_depts IS
BEGIN
add_depte;
add_depte;
add_depte('技术','中关村');
END create_depts;
/
-- 执行过程
EXEC create_depts;
-- 修改表的字段类型
ALTER TABLE dept_pl modify(deptno NUMBER(6));

-- 设置object_name列的宽度为20
col object_name for a20;
-- 查询过程
SELECT object_id,object_name,created,status FROM user_objects;
-- 删除过程
DROP PROCEDURE add_dept;

/*创建函数*/
CREATE OR REPLACE FUNCTION get_sal-- 创建函数
(v_id IN emp_pl.empno%TYPE)-- 函数的参数
RETURN NUMBER
IS
v_salary emp_pl.sal%TYPE:=0;-- 声明一个变量
BEGIN
SELECT sal
INTO v_salary
FROM emp_pl
WHERE empno=v_id;
RETURN v_salary;-- 返回数据
END get_sal;-- 结束函数
/
-- 匿名程序块中调用函数
SET verify OFF;
SET serveroutput ON;
DECLARE
v_sal emp_pl.sal%TYPE;
BEGIN
v_sal:=get_sal(7936);
DBMS_OUTPUT.PUT_LINE('7936号员工的工资为：'||v_sal);
END;
/
-- 利用函数给绑定变量赋值
VARIABLE g_salary NUMBER;-- 声明绑定变量
EXECUTE :g_salary:=get_sal(7936);-- 给绑定变量赋值
PRINT g_salary;-- 输出绑定变量的值
-- 在软件包中调用函数
EXECUTE DBMS_OUTPUT.PUT_LINE(get_sal(7936));
-- 在SQL语句中使用函数
SELECT ename,job,get_sal(empno) sal,deptno FROM emp_pl;


/*设置列的宽度*/
col FIRST_NAME for a15;
col LAST_NAME for a15;
col PHONE_NUMBER for a25;
/*创建函数*/
 CREATE OR REPLACE FUNCTION format_phone
 (p_phone_no IN VARCHAR2)
 RETURN VARCHAR2
 IS
 v_phone_no VARCHAR2(38);
 BEGIN
  v_phone_no:='('||SUBSTR(p_phone_no,1,3)||')'||SUBSTR(p_phone_no,4,3)||'-'||SUBSTR(p_phone_no,7);
  RETURN v_phone_no;
 END format_phone;
 /
 /*使用函数*/
 SELECT employee_id,first_name,last_name,format_phone(phone_number) "phone"
 FROM employees;
 
 /*使用函数的注意事项演示*/
 -- 1.SQL表达式中调用函数时，该函数不能包含DML语句
 CREATE OR REPLACE FUNCTION insert_plus_sal
 (p_sal IN NUMBER) RETURN NUMBER
 IS
 BEGIN
 INSERT INTO emp_pl (empno,ename,job,mgr,hiredate,sal,comm,deptno) VALUES (3838,'武大','特级烙饼师',928,SYSDATE,p_sal,3330,70);
 RETURN (p_sal+250);
 END insert_plus_sal;
 /
 UPDATE emp_pl
 SET sal=insert_plus_sal(9000)
 WHERE empno=7938;
 
 -- 2.从一个UPDATE或DELETE语句中调用一个函数时，该函数不能查询或修改数据库中表的数据
 CREATE OR REPLACE FUNCTION query_plus_sal(p_increase NUMBER)
 RETURN NUMBER
 IS
 v_sal NUMBER;-- 声明一个本地变量
 BEGIN
 SELECT sal INTO v_sal FROM emp_pl
 WHERE empno=7902;
 RETURN (v_sal+p_increase);
 END query_plus_sal;
 /
 UPDATE emp_pl
 SET sal=query_plus_sal(250)
 WHERE empno=7938;
 
 /*SQL中用名字表示法或混合表示法调用函数*/
 CREATE OR REPLACE FUNCTION test_11g
 (p_100 IN NUMBER DEFAULT 99,-- 参数默认值为99
 p_50 IN NUMBER DEFAULT 49)-- 参数默认值为49
 RETURN NUMBER
 IS
 v_num NUMBER;
 BEGIN
 v_num:=p_50+(p_100*2);
 RETURN v_num;
 END test_11g;
 /
 -- 使用名字表示法传递参数
 SELECT test_11g(p_100=>100) FROM dual;
 
 /*函数的发现与删除*/
 -- 设置object_name列的宽度为20个字符
 col object_name a20;
 -- 查询函数
 SELECT object_id,object_name,created,status
 FROM user_objects
 WHERE object_type='FUNCTION';
 -- 删除函数
 DROP FUNCTION test_11g;
 
 /*软件包的使用*/
 -- 1.创建"软件包说明"部分
 CREATE OR REPLACE PACKAGE salary_pkg IS
 v_std_salary NUMBER:=1380;-- 公有变量，可被其它软件包调用
 PROCEDURE reset_salary(p_new_sal NUMBER,p_grade NUMBER);-- 公有子程序，可被其它软件包调用
 END salary_pkg;
 /
 -- 2.调用软件包
 SET serveroutput ON;
 BEGIN
 DBMS_OUTPUT.PUT_LINE(salary_pkg.v_std_salary);
 END;
 /
 -- 3.给软件包里面的变量赋值
 BEGIN
 salary_pkg.v_std_salary:=1500;-- 给软件包全局变量赋值
 DBMS_OUTPUT.PUT_LINE(salary_pkg.v_std_salary);-- 调用其它软件包
 END;
 /
 
 -- 2.创建”软件包体“部分,注意：运行软件包体语句的时候，先运行软件包说明部分的语句然后再运行软件包体的语句这样才会编译成功，目前是为了编写方便说明和包体才分开的。
 CREATE OR REPLACE PACKAGE BODY salary_pkg IS
 FUNCTION validate(p_sal NUMBER,p_grade NUMBER) RETURN BOOLEAN IS
v_min_sal salgrade.losal %TYPE;
v_max_sal salgrade.hisal %TYPE;
BEGIN
SELECT losal,hisal
INTO v_min_sal,v_max_sal
FROM salgrade
WHERE grade=p_grade;
RETURN (p_sal BETWEEN v_min_sal AND v_max_sal);
END validate;-- 结束函数

PROCEDURE reset_salary(p_new_sal NUMBER,p_grade NUMBER) IS
BEGIN
IF validate(p_new_sal,p_grade) THEN
v_std_salary:=p_new_sal;
ELSE RAISE_APPLICATION_ERROR(-20038,'工资超限');
END IF;-- 结束if语句
END reset_salary;-- 结束过程
END salary_pkg;-- 结束软件包体
/


-- 3.调用软件包体
BEGIN
salary_pkg.reset_salary(3330,4);
DBMS_OUTPUT.PUT_LINE(salary_pkg.v_std_salary);
END;

-- 系统用户调用其它用户的软件包,注意只有系统管理员才能调用其它用户的软件包
EXECUTE SCOTT.salary_pkg.reset_salary(3000,4);

-- 无体软件包的应用，银行的利息
CREATE OR REPLACE PACKAGE icbc_interests IS
three_months CONSTANT NUMBER:=2.85;-- 三个月利息
six_months CONSTANT NUMBER:=3.05;-- 六个月利息
one_year CONSTANT NUMBER:=3.25;-- 一年利息;
two_year CONSTANT NUMBER:=3.75;-- 两年利息;
three_year CONSTANT NUMBER:=4.25;-- 三年利息;
five_year CONSTANT NUMBER:=4.75;-- 五年利息;
END icbc_interests;
-- 调用无体软件包
set serveroutput on;
BEGIN
DBMS_OUTPUT.PUT_LINE('六个月的利息为：'||icbc_interests.six_months);
END;

/*查询所有软件包*/
-- 设置object_name列的宽度为20
Col object_name for a20;
-- 查询所有软件包说明和软件包体
 SELECT object_id,object_name,object_type,created,status
 FROM user_objects
 WHERE object_type IN ('PACKAGE','PACKAGE BODY');
-- 删除软件包(连同软件包体一并删除)
DROP PACKAGE salary_pkg;
-- 删除软件包体
DROP PACKAGE BODY salary_pkg;

/*软件包中子程序的重载*/
-- 创建软件包说明
CREATE OR REPLACE PACKAGE dept_pkg IS
-- 过程重载
PROCEDURE add_dept(
p_deptno IN dept_pl.deptno%TYPE,
p_name IN dept_pl.dname%TYPE DEFAULT '服务',-- IN参数模式，默认值为‘服务’
p_loc IN dept_pl.loc%TYPE DEFAULT '狼山镇'-- IN参数模式，默认值为‘狼山镇’
);
PROCEDURE add_dept(
p_name IN dept_pl.dname%TYPE DEFAULT '服务',
p_loc IN dept_pl.loc%TYPE DEFAULT '狼山镇'
);
END dept_pkg;
-- 创建软件包体
CREATE OR REPLACE PACKAGE BODY dept_pkg IS
PROCEDURE add_dept(
p_deptno IN dept_pl.deptno%TYPE,
p_name IN dept_pl.dname%TYPE DEFAULT '服务',-- IN参数模式，默认值为‘服务’
p_loc IN dept_pl.loc%TYPE DEFAULT '狼山镇'-- IN参数模式，默认值为‘狼山镇’
)
IS
BEGIN
INSERT INTO dept_pl (deptno,dname,loc) VALUES (p_deptno,p_name,p_loc);
END;
PROCEDURE add_dept(
p_name IN dept_pl.dname%TYPE DEFAULT '服务',-- IN参数模式，默认值为‘服务’
p_loc IN dept_pl.loc%TYPE DEFAULT '狼山镇'-- IN参数模式，默认值为‘狼山镇’
)
IS
BEGIN
INSERT INTO dept_pl (deptno,dname,loc) VALUES (deptid_sequence.NEXTVAL,p_name,p_loc);
END;
END dept_pkg;

-- 调用软件包
EXECUTE dept_pkg.add_dept(38,'公关','公主坟');
EXECUTE dept_pkg.add_dept('公关','公主坟');

/*前向声明*/
 CREATE OR REPLACE PACKAGE salary_pkg IS
 v_std_salary NUMBER:=1380;-- 公有变量，可被其它软件包调用
 PROCEDURE reset_salary(p_new_sal NUMBER,p_grade NUMBER);-- 公有子程序，可被其它软件包调用
 END salary_pkg;
 /
 
  CREATE OR REPLACE PACKAGE BODY salary_pkg IS
-- 函数validate向前声明
FUNCTION validate(p_sal NUMBER,p_grade NUMBER) RETURN BOOLEAN;
  
PROCEDURE reset_salary(p_new_sal NUMBER,p_grade NUMBER) IS
BEGIN
IF validate(p_new_sal,p_grade) THEN
v_std_salary:=p_new_sal;
ELSE RAISE_APPLICATION_ERROR(-20038,'工资超限');
END IF;-- 结束if语句
END reset_salary;-- 结束过程

 FUNCTION validate(p_sal NUMBER,p_grade NUMBER) RETURN BOOLEAN IS
v_min_sal salgrade.losal %TYPE;
v_max_sal salgrade.hisal %TYPE;
BEGIN
SELECT losal,hisal
INTO v_min_sal,v_max_sal
FROM salgrade
WHERE grade=p_grade;
RETURN (p_sal BETWEEN v_min_sal AND v_max_sal);
END validate;-- 结束函数
END salary_pkg;-- 结束软件包体
/

/*软件包的初始化*/
-- 当软件包的某个组件被调用时，整个软件包都会被装到内存中
 CREATE OR REPLACE PACKAGE salary_pkg IS
 v_std_salary NUMBER:=1380;-- 公有变量，可被其它软件包调用
 PROCEDURE reset_salary(p_new_sal NUMBER,p_grade NUMBER);-- 公有子程序，可被其它软件包调用
 END salary_pkg;
 /
 
  CREATE OR REPLACE PACKAGE BODY salary_pkg IS
-- 函数validate向前声明
FUNCTION validate(p_sal NUMBER,p_grade NUMBER) RETURN BOOLEAN;
  
PROCEDURE reset_salary(p_new_sal NUMBER,p_grade NUMBER) IS
BEGIN
IF validate(p_new_sal,p_grade) THEN
v_std_salary:=p_new_sal;
ELSE RAISE_APPLICATION_ERROR(-20038,'工资超限');
END IF;-- 结束if语句
END reset_salary;-- 结束过程

 FUNCTION validate(p_sal NUMBER,p_grade NUMBER) RETURN BOOLEAN IS
 
SELECT losal,hisal
INTO v_min_sal,v_max_sal
FROM salgrade
WHERE grade=p_grade;
RETURN (p_sal BETWEEN v_min_sal AND v_max_sal);
END validate;-- 结束函数
-- 软件包体结尾处的程序块，只执行一次、被用于初始化软件包中的公有和私有的变量
BEGIN
SELECT AVG(sal)
INTO v_std_salary
FROM emp;
END salary_pkg;-- 结束软件包体
/
-- 调用软件包
SET serveroutput ON;
BEGIN
DBMS_OUTPUT.PUT_LINE(salary_pkg.v_std_salary);
END;

/*在SQL中使用软件包中的函数*/
-- 创建软件包说明
CREATE OR REPLACE PACKAGE dept_bi IS
FUNCTION average_salary(p_deptno IN NUMBER) RETURN NUMBER;
FUNCTION employee_sum(p_deptno IN NUMBER)RETURN NUMBER;
END dept_bi;
-- 创建软件包体
CREATE OR REPLACE PACKAGE BODY dept_bi IS
-- 计算部门平均工资的函数
FUNCTION average_salary(p_deptno IN NUMBER) RETURN NUMBER IS
v_average_salary emp.sal%TYPE;
BEGIN
SELECT AVG(sal)
INTO v_average_salary
FROM emp
WHERE deptno=p_deptno;
RETURN v_average_salary;
END average_salary;
-- 计算总人数的函数
FUNCTION employee_sum(p_deptno IN NUMBER) RETURN NUMBER IS
v_employee_sum NUMBER;
BEGIN
SELECT count(*)
INTO v_employee_sum
FROM emp
WHERE deptno=p_deptno;
RETURN v_employee_sum;
END employee_sum;
END dept_bi;
-- 输出部门20的部门编号、部门名称、平均工资、部门总人数
SELECT deptno,dname,dept_bi.average_salary(deptno),dept_bi.employee_sum(deptno) FROM dept WHERE deptno=20;
-- 输出所有部门的部门编号、部门名称、平均工资、部门总人数
SELECT deptno,dname,dept_bi.average_salary(deptno),dept_bi.employee_sum(deptno) FROM dept;

SET serveroutput on;
BEGIN
DBMS_OUTPUT.PUT_LINE(scott.salary_pkg.v_std_salary);
END;
EXECUTE salary_pkg.reset_salary(888,1);

/*软件包中变量的持续状态演示*/
-- 以scott用户登录
-- 1.得到的结果为2073.214
SET serveroutput ON;
BEGIN
DBMS_OUTPUT.PUT_LINE(salary_pkg.v_std_salary);
END;
/
-- 2.
EXECUTE salary_pkg.reset_salary(888,1);
-- 3.结果为888
SET serveroutput ON;
BEGIN
DBMS_OUTPUT.PUT_LINE(salary_pkg.v_std_salary);
END;
/
-- 以system用户登录
-- 1.结果为2073.214
SET serveroutput ON;
BEGIN
DBMS_OUTPUT.PUT_LINE(scott.salary_pkg.v_std_salary);
END;
/
-- 2.
UPDATE scott.salgrade SET losal=900 WHERE grade=1;
-- 3. 
SELECT * FROM scott.salgrade;
-- 4.
BEGIN
DBMS_OUTPUT.PUT_LINE(scott.salary_pkg.v_std_salary);
END;
/
-- 5.
EXECUTE scott.salary_pkg.reset_salary(938,1);
-- 6.
BEGIN
DBMS_OUTPUT.PUT_LINE(scott.salary_pkg.v_std_salary);
END;
/
-- 7.
EXECUTE scott.salary_pkg.reset_salary(898,1);
-- 8.
BEGIN
DBMS_OUTPUT.PUT_LINE(scott.salary_pkg.v_std_salary);
END;
/
-- 9.
SELECT * FROM salgrade;

/*软件包中cursor的持续状态*/
-- 创建软件包说明，里面所声明的都是公有的
CREATE OR REPLACE PACKAGE employee_pkg IS
PROCEDURE open_emp;-- 声明一个过程
FUNCTION next_employee(p_n NUMBER:=1) RETURN BOOLEAN;-- 声明一个函数
PROCEDURE close_emp;
END employee_pkg;
/

-- 创建软件包体
CREATE OR REPLACE PACKAGE BODY employee_pkg IS
CURSOR emp_cursor IS
SELECT empno FROM emp;
-- open_emp过程的实现
PROCEDURE open_emp IS
BEGIN
IF NOT emp_cursor%ISOPEN THEN
OPEN emp_cursor;
END IF;
END open_emp;
-- next_employee函数的实现
FUNCTION next_employee(p_n NUMBER:=1) RETURN BOOLEAN IS
v_emp_id emp.empno%TYPE;
BEGIN
FOR count IN 1..p_n LOOP
FETCH emp_cursor INTO v_emp_id;
EXIT WHEN emp_cursor%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Employee number'||v_emp_id);
END LOOP;
RETURN emp_cursor%FOUND;
END next_employee;
-- close_emp过程的实现
PROCEDURE close_emp IS
BEGIN
IF emp_cursor%ISOPEN THEN
CLOSE emp_cursor;
END IF;
END close_emp;
END employee_pkg;
/
-- 演示
SET SERVEROUTPUT ON;
EXECUTE employee_pkg.open_emp;

DECLARE
more_rows BOOLEAN:=employee_pkg.next_employee(5);
BEGIN
IF NOT more_rows THEN
employee_pkg.close_emp;
END IF;
END;

/*在软件包中使用INDEX BY记录表*/
-- 创建软件包说明
CREATE OR REPLACE PACKAGE employee_dog IS
TYPE emp_table_type IS TABLE OF emp%ROWTYPE-- 数据的类型是emp表一整行的数据类型
INDEX BY PLS_INTEGER;-- 索引的数据类型
PROCEDURE get_emp(p_emps OUT emp_table_type);
END employee_dog;
/

-- 创建软件包体
CREATE OR REPLACE PACKAGE BODY employee_dog IS
PROCEDURE get_emp(p_emps OUT emp_table_type) IS
v_count BINARY_INTEGER:=1;
BEGIN
-- 循环cursor
FOR emp_record IN (SELECT * FROM emp) LOOP
p_emps(v_count):=emp_record;
v_count:=v_count+1;-- 下标加1
END LOOP;
END get_emp;
END employee_dog;
/
-- 调用
SET serveroutput ON;
DECLARE
employee employee_dog.emp_table_type;
BEGIN
employee_dog.get_emp(employee);-- 返回数据给employee变量
DBMS_OUTPUT.PUT_LINE('Emp 8:   '||employee(8).ename||','||employee(8).job||','||employee(8).sal);
END;


/*创建语句触发器*/
CREATE OR REPLACE TRIGGER secure_emp
BEFORE INSERT ON emp_pl-- BEFORE：为执行的时机，INSERT ON emp_pl：指在emp_pl表执行插入操作之前执行
BEGIN
IF(TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN')) OR-- 如果是在周六和周日
(TO_CHAR(SYSDATE,'HH24:MI')-- 或者不是早上8点到晚上6点
NOT BETWEEN '08:00' AND '18:00') THEN
RAISE_APPLICATION_ERROR(-20038,'操作系统已经记录在系统中，因为非工作时间不允许插入数据');
END IF;
END;
/

INSERT INTO emp_pl (empno,ename,hiredate,job,sal) VALUES (9000,'武大',sysdate,'烙饼',7970.33);
SELECT * FROM emp_pl;

/*创建语句触发器，一个触发器里面使用多个事件*/
CREATE OR REPLACE TRIGGER secure_emp
BEFORE INSERT OR DELETE OR UPDATE ON emp_pl
BEGIN
IF (TO_CHAR(sysdate,'DY') IN ('SAT','SUN')) OR
NOT (TO_CHAR(sysdate,'hh24') BETWEEN '08' AND '18') THEN
IF INSERTING THEN -- 发生insert 事件时执行此语句
RAISE_APPLICATION_ERROR(-20038,'操作已记录在系统中，因为非工作时间不允许向员工中添加数据！');
ELSIF DELETING THEN -- 发生delete 事件时执行此语句
RAISE_APPLICATION_ERROR(-20138,'操作已记录在系统中,因为非工作时间不允许删除员工表中的数据！');
ELSIF UPDATING ('SAL') THEN -- 更改数据表某一列时执行此语句
RAISE_APPLICATION_ERROR(-20138,'操作已记录在系统中,因为非工作时间不允许更改员工工资！');
ELSE-- 其它操作时执行此语句
RAISE_APPLICATION_ERROR(-20138,'操作已记录在系统中,因为非工作时间不允许更改员工表中的数据！');
END IF;-- 结束内层if语句
END IF;-- 结束外层if语句
END;-- 结束触发器
INSERT INTO emp_pl (empno,ename,hiredate,job,sal) VALUES (9000,'武大',sysdate,'烙饼',7970.33);
UPDATE emp_pl SET sal=sal*1.1 WHERE deptno=10;
UPDATE emp_pl SET comm=300 WHERE deptno=10;
DELETE FROM emp_pl WHERE empno=9000;

/*创建行触发器*/
CREATE OR REPLACE TRIGGER restrict_salary
BEFORE INSERT OR UPDATE ON emp_pl--在emp_pl表执行insert、update事件之前触发触发器
FOR EACH ROW-- 指定触发器是行触发器
BEGIN
IF NOT(:NEW.job IN ('MANAGER','PRESIDENT','ANALYST'))
AND :NEW.sal>3800 THEN
RAISE_APPLICATION_ERROR(-20438,'普通员工的工资不能超过3800块！！！');
END IF;
END;

INSERT INTO emp_pl (empno,ename,hiredate,job,sal) VALUES (9000,'武大',sysdate,'烙饼',3800);
UPDATE emp_pl SET sal=3805 WHERE empno=7834;

/*:OLD、:NEW限定符的使用*/
-- 创建数据表测试
CREATE TABLE audit_emp(
user_name VARCHAR2(38),
time_stamp DATE,
id NUMBER(4),
new_name VARCHAR2(10),
old_name VARCHAR2(10),
new_job VARCHAR2(10),
old_job VARCHAR2(10),
new_salary NUMBER(7,2),
old_salary NUMBER(7,2),
deptno NUMBER(9)
);

-- 创建触发器
CREATE OR REPLACE TRIGGER audit_emp_valueS
AFTER INSERT OR DELETE OR UPDATE ON emp_pl
FOR EACH ROW --行触发器
BEGIN
INSERT INTO audit_emp (user_name,time_stamp,id,new_name,old_name,new_job,old_job,new_salary,old_salary,deptno)
VALUES (USER,SYSDATE,:OLD.empno,:NEW.ename,:OLD.ename,:NEW.job,:OLD.job,:NEW.sal,:OLD.sal,:NEW.deptno);
END;

set line 150;
col USER_NAME for a15;
col OLD_NAME for a15;
col NEW_NAME for a15;
col OLD_JOB for a15;
col NEW_JOB for a15;

INSERT INTO emp_pl (empno,ename,job,sal) VALUES (7999,'苏妲己','程序媛',5556.55);
DELETE FROM emp_pl WHERE empno=7999;
UPDATE emp_pl SET ename='纣王',job='项目经理',sal=9999.99 WHERE empno=7999;

/*利用when子句有条件触发行触发器*/
CREATE OR REPLACE TRIGGER deriver_commission_pct
BEFORE INSERT OR UPDATE ON emp_pl
FOR EACH ROW-- 行触发器
WHEN (new.job='SALESMAN')-- 如果条件成立才会走下面的PL/SQL匿名块
BEGIN
IF INSERTING THEN-- 如果是添加数据
:new.comm:=0;
ELSE /*UPDATING salary*/
IF :old.comm is null THEN
:new.comm:=0;
ELSE
:new.comm:=:old.comm*(:new.sal/:old.sal);
:new.deptno:=10;
END IF;-- 内层if结束
END IF;-- 外层if结束
END;-- 触发器结束
/

UPDATE emp_pl SET sal=1250 WHERE empno=7499;
SELECT 300*1250/1600 FROM dual;
UPDATE emp_pl SET sal=1800 WHERE empno=7521;
SELECT 500*1800/1250 FROM dual;
select * from emp_pl where job='CLERK';
UPDATE emp_pl SET sal=9998 WHERE empno=7369;

INSERT INTO emp_pl(empno,ename,sal,job) values (7666,'小明',5000,'SALESMAN');
INSERT INTO emp_pl(empno,ename,sal,job) values (7856,'小强',6000,'SALESMAN');
UPDATE emp_pl SET sal=6000 WHERE empno=7666;
delete from emp_pl where empno=7666 or empno=7856;

-- 创建数据表
CREATE TABLE emp_pl AS
SELECT * FROM emp;

CREATE TABLE dept_pl AS
SELECT * FROM dept;
-- 为主表添加主键约束
ALTER TABLE dept_pl ADD CONSTRAINT dept_pl_deptno_pk PRIMARY KEY(deptno);
-- 为从表添加外键约束
ALTER TABLE emp_pl ADD CONSTRAINT emp_pl_deptno_fk FOREIGN KEY(deptno) REFERENCES dept_pl(deptno);
-- 设置列的宽度
COL owner FOR A10;
COL constraint_name FOR A20;
-- 设置整行数据的长度
SET line 100;
-- 查看表中定义的约束
SELECT owner,constraint_name,constraint_type,table_name FROM user_constraints WHERE table_name IN ('DEPT_PL','EMP_PL');
-- 查看表中约束定义的位置
SELECT owner,constraint_name,table_name,column_name FROM user_cons_columns WHERE table_name IN ('DEPT_PL','EMP_PL');

/*利用触发器实现完整性约束*/
UPDATE emp_pl set deptno=38 WHERE empno=7900;
-- 创建触发器
CREATE OR REPLACE TRIGGER emp_dept_fk_trg
AFTER UPDATE OF deptno ON emp_pl -- emp_pl表的deptno列执行update操作之后执行触发器
FOR EACH ROW
BEGIN
INSERT INTO dept_pl VALUES(:NEW.deptno,'Dept '||:NEW.deptno,'公主坟');
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
NULL;
END;

/*INSTEAD OF行触发器*/
-- 1.创建new_emps数据表
CREATE TABLE new_emps AS SELECT empno,ename,sal,deptno FROM emp;
-- 2.创建new_depts数据表
CREATE TABLE new_depts AS 
SELECT d.deptno,d.dname,sum(e.sal) dept_sal
FROM emp e,dept d
WHERE e.deptno=d.deptno
GROUP BY d.deptno,d.dname;

-- 创建视图
CREATE OR REPLACE VIEW emp_details AS
SELECT e.empno,e.ename,e.sal,
e.deptno,d.dname
FROM new_emps e,new_depts d
WHERE e.deptno=d.deptno;
-- 连接到系统管理员
connect system/try369
-- 授予创建视图的权限给scott用户
grant create view to scott;
-- 创建触发器
CREATE OR REPLACE TRIGGER new_emp_dept
INSTEAD OF INSERT OR DELETE OR UPDATE ON emp_details
FOR EACH ROW -- 行触发器
BEGIN
IF INSERTING THEN-- 如果是插入操作
INSERT INTO new_emps
VALUES(:NEW.empno,:NEW.ename,:NEW.sal,:NEW.deptno);
UPDATE new_depts
SET dept_sal=dept_sal+:NEW.sal
WHERE deptno=:NEW.deptno;
ELSIF DELETING THEN -- 如果是删除操作
DELETE FROM new_emps
WHERE empno=:OLD.empno;
UPDATE new_depts SET
dept_sal=dept_sal-:OLD.sal
WHERE deptno=:OLD.deptno;
ELSIF UPDATING('sal') THEN-- 如果sal列有修改操作
UPDATE new_emps SET
sal=:NEW.sal
WHERE empno=:NEW.empno;
UPDATE new_depts SET
dept_sal=dept_sal+(:NEW.sal-:OLD.sal)
WHERE deptno=:NEW.deptno;
ELSIF UPDATING('deptno') THEN-- 如果deptno列有修改操作
UPDATE new_emps SET
deptno=:NEW.deptno
WHERE deptno=:OLD.deptno;
UPDATE new_depts SET
dept_sal=dept_sal-:OLD.sal
WHERE deptno=:OLD.deptno;
UPDATE new_depts SET
dept_sal=dept_sal+:NEW.sal
WHERE deptno=:NEW.deptno;
END IF;
END;

-- 向视图插入数据
INSERT INTO emp_details
VALUES(3838,'武大',3250,30,'公关');
-- 浏览20号部门的员工
SELECT * FROM emp_details
WHERE deptno=20;
-- 修改编号是7369的员工的工资
UPDATE emp_details
SET sal=1800
WHERE empno=7369;
-- 修改部门编号
UPDATE emp_details
SET deptno=40
WHERE deptno=30

/*禁止或激活数据库的触发器*/
ALTER TRIGGER EMP_DEPT_FK_TRG ENABLE;--DISABLE
/*禁止或激活表上所有的触发器*/
ALTER TABLE emp_pl DISABLE ALL TRIGGERS;-- ENABLE
/*重新编译触发器*/
ALTER TRIGGER emp_dept_fk_trg COMPILE;
/*删除触发器*/
DROP TRIGGER emp_dept_fk_trg;

-- 设置行可容纳的字符数为100
SET LINE 100;
-- 设置object_name列可容纳的字符数量为25
COL object_name FOR a25;
-- 利用user_objects表查看触发器的详细信息
SELECT object_id,object_name,created,status
FROM user_objects
WHERE object_type='TRIGGER';
-- 利用user_triggers表查看触发器的详细信息,在实际中多用此表
COL trigger_name FOR a23;
COL triggering_event FOR a30;
COL trigger_type FOR a20;
SELECT trigger_name,trigger_type,triggering_event,status
FROM user_triggers;


/*批量绑定FORALL的实例*/
-- 创建过程
CREATE OR REPLACE PROCEDURE bulk_raise_salary(p_percent NUMBER) IS
TYPE idlist_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
v_empno idlist_type;
BEGIN
v_empno(1):=7788;v_empno(2):=7844;v_empno(3):=7876;
v_empno(4):=7900;v_empno(2):=7902;v_empno(3):=7934;
FORALL i IN v_empno.FIRST .. v_empno.LAST-- 利用FORALL关键字批量绑定SQL语法，之后一次性将SQL语法发送给SQL引擎执行
UPDATE emp_pl
SET sal=(1+p_percent/100)*sal
WHERE empno=v_empno(i);
END;
/

/*cursor属性%BULK_ROWCOUNT的应用*/
CREATE TABLE  name_table(name VARCHAR2(38));
SET SERVEROUTPUT ON;
DECLARE
TYPE name_list_type IS TABLE OF VARCHAR2(38)
INDEX BY PLS_INTEGER;
v_names name_list_type;
BEGIN
v_names(0):='潘金莲';
v_names(1):='苏妲己';
v_names(0):='杨贵妃';
v_names(0):='武则天';
v_names(0):='花木兰';
FORALL i IN v_names.FIRST .. v_names.LAST-- 利用FORALL关键字批量绑定SQL语法，之后一次性将SQL语法发送给SQL引擎执行
INSERT INTO name_table(name) VALUES (v_names(i));
FOR i IN v_names.FIRST .. v_names.LAST LOOP-- 开始循环
dbms_output.put_line('Inserted '||
SQL%BULK_ROWCOUNT(i)||' row(s) '||-- SQL%BULK_ROWCOUNT(i)返回执行DML操作时受影响的行数
'ON iteration '||i);
END LOOP;-- 结束循环
END;-- 结束PL/SQL程序块
/

/*在查询语句中使用 BULK COLLECT INTO 子句 */
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE bulk_get_emps(p_deptno NUMBER) IS
TYPE emp_tab_type IS-- 声明一个数组
TABLE OF emp_pl %ROWTYPE--数据类型为emp_pl一整行数据的数据类型
INDEX BY PLS_INTEGER;--数组索引的数据类型
v_emps emp_tab_type;
BEGIN
SELECT * BULK COLLECT INTO v_emps-- 利用BULK COLLECT INTO 关键字将数据存放到数组
FROM emp_pl
WHERE deptno=p_deptno;
FOR i IN 1 .. v_emps.COUNT LOOP
DBMS_OUTPUT.PUT_LINE(v_emps(i).empno||' '||v_emps(i).ename||' '||v_emps(i).job||' '||v_emps(i).sal);
END LOOP;
END;
/
-- 执行过程
EXECUTE bulk_get_emps(20);

/*在FETCH语句中使用BULK COLLECT INTO子句*/
CREATE OR REPLACE PROCEDURE bulk_get_emps2(p_deptno NUMBER) AS
CURSOR emp_cursor IS --声明cursor
SELECT * FROM emp_pl
WHERE deptno=p_deptno;
TYPE emp_tab_type IS TABLE OF emp_cursor%ROWTYPE;-- 声明集合
v_emps emp_tab_type;
BEGIN
OPEN emp_cursor;-- 打开cursor
FETCH emp_cursor BULK COLLECT INTO v_emps;-- 利用BULK COLLECT INTO 子句从cursor中获取数据到v_emps集合
CLOSE emp_cursor;-- 关闭cursor
FOR i IN 1..v_emps.COUNT LOOP-- 遍历集合
DBMS_OUTPUT.PUT_LINE(v_emps(i).empno||' '||v_emps(i).ename||' '||v_emps(i).job);
END LOOP;-- 结束循环
END;-- 结束过程
/
-- 执行过程
EXECUTE bulk_get_emps2(30);
/*LIMIT关键字获取指定行数数据*/
CREATE OR REPLACE PROCEDURE bulk_get_emps2(p_deptno NUMBER,nrows NUMBER) AS
CURSOR emp_cursor IS --声明cursor
SELECT * FROM emp_pl
WHERE deptno=p_deptno;
TYPE emp_tab_type IS TABLE OF emp_cursor%ROWTYPE;-- 声明集合
v_emps emp_tab_type;
BEGIN
OPEN emp_cursor;-- 打开cursor
FETCH emp_cursor BULK COLLECT INTO v_emps LIMIT nrows;-- 利用BULK COLLECT INTO 子句从cursor中获取数据到v_emps集合
CLOSE emp_cursor;-- 关闭cursor
FOR i IN 1..v_emps.COUNT LOOP-- 遍历集合
DBMS_OUTPUT.PUT_LINE(v_emps(i).empno||' '||v_emps(i).ename||' '||v_emps(i).job);
END LOOP;-- 结束循环
END;-- 结束过程
/

/*RETURNING和BULK COLLECT INTO关键字的使用*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE bulk_raise_salary2(p_percent NUMBER) IS
TYPE idlist_type IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE sallist_type IS TABLE OF emp_pl.sal%TYPE INDEX BY BINARY_INTEGER;
v_empno idlist_type;
v_new_sals sallist_type;
BEGIN
v_empno(1):=7788;v_empno(2):=7844;v_empno(3):=7876;
v_empno(4):=7900;v_empno(2):=7902;v_empno(3):=7934;
FORALL i IN v_empno.FIRST .. v_empno.LAST-- 利用FORALL关键字批量绑定SQL语法，之后一次性将SQL语法发送给SQL引擎执行
UPDATE emp_pl
SET sal=(1+p_percent/100)*sal
WHERE empno=v_empno(i)
RETURNING sal BULK COLLECT INTO v_new_sals;

FOR i IN 1..v_new_sals.COUNT LOOP
DBMS_OUTPUT.PUT_LINE(v_empno(i)||'  '||v_new_sals(i));
END LOOP; 
END;
/
-- 执行过程
EXECUTE bulk_raise_salary2(10);

-- 变异表及在变异表上触发器的限制，所谓的变异表就是正在被DML语句操作的表
CREATE OR REPLACE TRIGGER check_salary
AFTER INSERT OR UPDATE OF sal, job-- 在sal、job列插入或更新操作之前触发
ON emp_pl-- 触发器作用与emp_pl表
FOR EACH ROW-- 行触发器
WHEN (NEW.job<>'PRESIDENT')-- 行触发器的WHEN子句
-- 声明两个变量
DECLARE
v_min_sal emp_pl.sal%TYPE;
v_max_sal emp_pl.sal%TYPE;
BEGIN
SELECT MIN(sal),MAX(sal)
INTO v_min_sal,v_max_sal
FROM emp_pl
WHERE job=:NEW.job;
IF :NEW.sal<v_min_sal OR :NEW.sal>v_max_sal  THEN
RAISE_APPLICATION_ERROR('-20038','工资已超出允许的范围！');-- RAISE_APPLICATION_ERROR过程的使用，让抛出的异常像Oracle预定义的异常一样
END IF;
END;
/
UPDATE emp_pl SET sal='1350' WHERE ename='SMITH';

/*利用复合触发器解决变异表的错误*/
CREATE OR REPLACE TRIGGER check_salary
FOR INSERT OR UPDATE OF sal,job-- sal列和job列插入和修改数据时触发
ON emp_pl-- 触发器作用于emp_pl表
WHEN (NEW.job<>'PRESIDENT')
COMPOUND TRIGGER --复合触发器
TYPE sal_t IS TABLE OF emp_pl.sal%TYPE;-- 声明一个INDEX BY表（PL/SQL表或PL/SQL集合）
min_sal sal_t;-- 声明一个变量
max_sal sal_t;-- 声明一个变量
TYPE deptno_t IS TABLE OF emp_pl.deptno%TYPE;-- 声明一个INDEX BY表（PL/SQL表或PL/SQL集合）
dept_ids deptno_t;
TYPE dept_sal_t IS TABLE OF emp_pl.sal%TYPE
INDEX BY VARCHAR2(38);-- INDEX BY表下标的数据类型
dept_min_sal dept_sal_t;
dept_max_sal dept_sal_t;
-- DML语句执行之前触发
BEFORE STATEMENT IS
BEGIN
SELECT MIN(sal),MAX(sal),NVL(deptno,-1)
BULK COLLECT INTO min_sal,max_sal,dept_ids
FROM emp_pl
GROUP BY deptno;
-- FOR循环语句
FOR j IN 1.. dept_ids.COUNT() LOOP
dept_min_sal(dept_ids(j)):=min_sal(j);
dept_max_sal(dept_ids(j)):=max_sal(j);
END LOOP;-- 结束循环
END BEFORE STATEMENT;-- 结束BEFORE STATEMENT程序段
-- 被DML语句所影响的每一行记录之后触发
AFTER EACH ROW IS
BEGIN
IF :NEW.sal<dept_min_sal(:NEW.deptno)
OR :NEW.sal>dept_max_sal(:NEW.deptno) THEN
RAISE_APPLICATION_ERROR(-20038,'新工资已超出允许的范围！');-- 抛出异常
END IF;-- 结束IF语句
END AFTER EACH ROW;-- 结束AFTER EACH ROW程序段
END check_salary;-- 结束复合触发器
/

UPDATE emp_pl SET sal='1100' WHERE ename='SMITH';

/ *基于DDL语句或系统事件的触发器，数据库触发器必须要有权限才能创建*/
-- 用户登录和登出时触发器的应用
-- 创建日志表
CREATE TABLE log_onoff_table(
user_id VARCHAR2(38),-- 用户id
log_date DATE,-- 记录日期
action VARCHAR2(48)-- 动作
);
-- 创建系统事件触发器，记录用户登录
CREATE OR REPLACE TRIGGER  logn_trigger
AFTER LOGON -- 用户登录事件 
ON DATABASE-- 数据库
BEGIN-- 触发器体
INSERT INTO log_onoff_table (user_id,log_date,action) VALUES (USER,SYSDATE,'用户登录');
END;
/

-- 创建系统事件触发器，记录用户退出
CREATE OR REPLACE TRIGGER logoff_trigger
BEFORE LOGOFF -- 用户退出事件
ON DATABASE
BEGIN
INSERT INTO log_onoff_table (user_id,log_date,action) VALUES (USER,SYSDATE,'用户退出');
END;
/
-- 查看用户的登录登出情况
select user_id,TO_CHAR(log_date,'YYYY-MM-DD HH24:MI:SS'),action from log_onoff_table;
-- 查看idle time
SELECT * FROM dba_profiles WHERE resource_name='IDLE_TIME' AND profile='DEFAULT';
-- 修改用户在数据库中的空闲时间
ALTER PROFILE default LIMIT IDLE_TIME 20;
-- 恢复profile文件默认的配置
ALTER PROFILE default LIMIT IDLE_TIME UNLIMITED;

/*触发器中的call语句*/
-- 创建存储过程
CREATE OR REPLACE PROCEDURE log_action IS
BEGIN
DBMS_OUTPUT.PUT_LINE('正在删除记录！');
END;
/
-- 创建触发器使用call语句
CREATE OR REPLACE TRIGGER log_emp_pl
BEFORE DELETE ON emp_pl
CALL log_action/*不需要分号*/
/
CREATE OR REPLACE TRIGGER confirme
AFTER DELETE ON emp_pl
BEGIN
DBMS_OUTPUT.PUT_LINE('记录已删除！');
END;
/
-- 使用软件包输出
set serveroutput on;
-- 模拟删除记录
DELETE FROM emp_pl WHERE empno=7934;


/*标准化异常和标准化异常处理（即将非预定义异常和自定义异常封装到一个软件包然后方便调用）*/
-- 软件包封装异常
CREATE OR REPLACE PACKAGE emp_error_pkg IS
-- 声明异常
e_insert_excep EXCEPTION;
e_invalid_employee EXCEPTION;
e_emp_remaining EXCEPTION;
-- 异常名与错误代码关联
PRAGMA EXCEPTION_INIT(e_insert_excep,-02291);
PRAGMA EXCEPTION_INIT(e_invalid_employee,-20274);
PRAGMA EXCEPTION_INIT(e_emp_remaining,-2292);
END emp_error_pkg;
/
-- 调用软件包中的异常
SET verify OFF;
SET serveroutput ON;
DECLARE
v_deptno dept.deptno%TYPE:=&p_deptno;
BEGIN
DELETE FROM dept WHERE deptno=v_deptno;
COMMIT;
EXCEPTION
WHEN emp_error_pkg.e_emp_remaining THEN
DBMS_OUTPUT.PUT_LINE('无法删除这个部门-----部门'||TO_CHAR(v_deptno)||',因为这个部门还有员工！');
END;
/

/*标准化常量*/
-- 查看emp表工资状况
SELECT MIN(SAL),AVG(SAL),MAX(SAL) FROM emp;
-- 在软件包中定义常量
CREATE OR REPLACE PACKAGE emp_constant_pkg IS
c_min_sal CONSTANT NUMBER(5):=1038;
c_avg_sal CONSTANT NUMBER(5):=2108;
c_max_sal CONSTANT NUMBER(5):=9988;
END emp_constant_pkg;
/
SELECT empno,ename,job,sal,deptno
FROM emp
WHERE sal<emp_constant_pkg.c_min_sal;-- 不能再SQL语句中使用软件包中的常量

SELECT empno,ename,job,sal,deptno
FROM emp
WHERE sal<1038;

BEGIN
UPDATE emp SET sal=sal+250
WHERE sal<emp_constant_pkg.c_min_sal;
END;
/
SELECT empno,ename,job,sal,deptno FROM emp WHERE empno IN(7369,7900);

/*本地子程序的应用，本地子程序的应用指的是在软件包、过程、PL/SQL匿名程序块的声明段的结尾处声明的函数或过程*/
SET verify OFF;
SET serveroutput ON;
CREATE OR REPLACE PROCEDURE get_emp_sal(p_id NUMBER) IS
v_emp emp%ROWTYPE;
-- 本地子程序
FUNCTION sal_tax(p_sal NUMBER) RETURN NUMBER IS
BEGIN
RETURN p_sal*0.8;
END sal_tax;
BEGIN
SELECT * INTO v_emp
FROM emp
WHERE empno=p_id;
-- 调用本地子程序
DBMS_OUTPUT.PUT_LINE('税后工资为：'||sal_tax(v_emp.sal));
END get_emp_sal;
/

/*程序的定义者权限与调用者权限，当一个程序被调用时，如果以程序的拥有者的权限执行该程序就是定义者权限；如果以调用者的权限执行该程序那就是调用者权限*/
-- 创建一个是调用者权限的过程
CREATE OR REPLACE PROCEDURE add_dept_authid(
v_name dept_pl.dname%TYPE DEFAULT '服务',
v_loc dept_pl.loc%TYPE DEFAULT '狼山'
)
AUTHID CURRENT_USER IS --声明调用者权限
BEGIN
INSERT INTO dept_pl VALUES (50,v_name,v_loc);
END add_dept_authid;
/
EXECUTE scott.add_dept_authid('厨师','深圳');

/*自治事务，事务分为主事务和自治事务，主事务和自治事务之间互不影响互相独立*/
CREATE TABLE txn
(acc_id NUMBER(10) PRIMARY KEY,
amount NUMBER(10,2),
op_date DATE);

CREATE TABLE usage
(card_id NUMBER(10) PRIMARY KEY,
loc NUMBER(8),
op_date DATE);
-- 创建时自治事务的过程
CREATE OR REPLACE PROCEDURE log_usage
(p_card_id NUMBER,p_loc NUMBER)
 IS
PRAGMA AUTONOMOUS_TRANSACTION;-- 自治事务关键字
BEGIN
INSERT INTO usage VALUES(p_card_id,p_loc,SYSDATE);
COMMIT;-- 自治事务结束
END log_usage;
/

CREATE OR REPLACE PROCEDURE bank_trans
(p_cardnbr NUMBER,p_loc NUMBER) IS
BEGIN
log_usage(p_cardnbr,p_loc);
INSERT INTO txn VALUES (100250,1250,SYSDATE);
END bank_trans;
/
-- 执行过程
EXECUTE bank_trans(0038,250);
rollback;-- 回滚没提交的事务


/*将数据缓存在内存中（缓存在内存中的数据如果很久很久没用也是会被清除掉的）*/
-- 获取hr用户对象的内存使用情况(system管理员执行)
SELECT name,namespace,sharable_mem,executions,kept
FROM v$db_object_cache
WHERE owner='HR';
-- 登录管理员
connect sys/try369 as sysdba
-- sys管理员运行语句
@ D:\app\cao\product\11.2.0\dbhome_1\RDBMS\ADMIN\dbmspool.sql;
-- 使用软件包dbms_shared_pool中的keep过程将ADD_JOB_HISTORY过程改为常驻内存
EXECUTE dbms_shared_pool.keep('HR.ADD_JOB_HISTORY');
-- 将共享池的对象清除（常驻内存的程序除外即KEP为YES的对象不能被此命令清除）
ALTER SYSTEM FLUSH SHARED_POOL;
-- 使用软件包dbms_shared_pool中的unkeep过程将ADD_JOB_HISTORY过程退出常驻内存
EXECUTE dbms_shared_pool.unkeep('HR.ADD_JOB_HISTORY');

/*将数据缓存在内存中*/
-- 查看scott用户的表是否缓存
SELECT table_name,tablespace_name,cache
FROM user_tables;
-- 将emp表改为缓存表
ALTER TABLE emp cache;
-- 将emp表改为非缓存表
ALTER TABLE emp nocache;
/*将数据常驻内存*/
-- 登录system用户授予scott用户能查询所有数据表的权限
GRANT select any table to scott;
-- 创建客户表
CREATE TABLE customers
AS SELECT * FROM sh.customers;
-- 创建销售
CREATE TABLE sales
AS SELECT * FROM sh.sales;
-- 查看客户表
SELECT * FROM customers WHERE ROWNUM=1;
-- 查看销售表
SELECT * FROM sales WHERE ROWNUM=1;
-- 创建索引，索引与sales表的cust_id字段关联
CREATE INDEX sales_cust_id_idx on sales(cust_id);
--  使用dbms_stats.软件包的gather_index_stats过程收集scott用户中sales_cust_id_idx索引的统计信息
EXECUTE dbms_stats.gather_index_stats('SCOTT','SALES_CUST_ID_IDX');
--  使用dbms_stats.软件包的gather_table_stats过程收集scott用户中customers表的统计信息
EXECUTE dbms_stats.gather_table_stats('SCOTT','CUSTOMERS');
-- 从数据字典dba_segments中获取scott用户中CUSTOMERS表和SALES_CUST_ID_IDX索引的统计信息(system管理员登录执行)
SELECT owner,segment_name,segment_type,blocks
FROM dba_segments
WHERE owner LIKE 'SCOTT'
AND segment_name IN('CUSTOMERS','SALES_CUST_ID_IDX');
-- 求出CUSTOMERS表和SALES_CUST_ID_IDX索引的内存总数
SELECT (1536+2048)*8/1024 FROM dual;
-- 查看当前数据库数据块的大小（需管理员sys或system执行）
show parameter block_size;
-- 查看keep pool内存缓冲区的大小
show parameter db_keep_cache_size;
-- 使用数据字典v$buffer_pool查看当前所有数据库内存缓冲区信息（需管理员sys或system执行）
SELECT id,name,block_size,buffers
FROM  v$buffer_pool;
-- 设置keep pool内存缓冲区的大小为64M
ALTER SYSTEM SET db_keep_cache_size=64M;
-- 使用数据字典user_tables获取该用户(scott用户)的CUSTOMERS表所使用的数据缓冲区信息
SELECT table_name,tablespace_name,buffer_pool,cache
FROM user_tables
WHERE table_name='CUSTOMERS';
-- 将数据表CUSTOMERS表所使用的数据缓冲区改为keep
ALTER TABLE customers STORAGE(buffer_pool keep);
-- 使用数据字典user_indexes获取索引名是sales_cust_id_idx的索引
SELECT index_name,table_name,tablespace_name,buffer_pool
FROM user_indexes
WHERE index_name='SALES_CUST_ID_IDX';
-- 将索引sales_cust_id_idx所使用的数据缓冲区改为keep
ALTER INDEX sales_cust_id_idx STORAGE(buffer_pool keep);
-- 将表customers所使用的数据缓冲区改为default
ALTER TABLE customers STORAGE(buffer_pool default);
-- 将索引sales_cust_id_idx所使用的数据缓冲区改为default
ALTER INDEX sales_cust_id_idx STORAGE(buffer_pool default);
-- 将表customers缓存
ALTER TABLE customers CACHE;
-- 将表customers不缓存
ALTER TABLE customers NOCACHE;
-- 释放keep pool内存缓冲区所使用的空间(管理员system)
ALTER SYSTEM SET db_keep_cache_size=0;

/*将查询结果缓存在内存*/
-- 列出初始化参数result_cache_mode的当前设置,result_cache_mode设置是Oracle查询优化器管理缓存机制的关键，result_cache_mode有三种设置分别是AUTO、MANUAL、FORCE
show parameter result_cache_mode;
-- 创建plan_table表
 @ D:\app\cao\product\11.2.0\dbhome_1\RDBMS\ADMIN\utlxplan.sql
 -- 使用EXPLANIN plan for 命令解释一个带有分组函数和group by子句的查询语句,语句开启了RESULT_CACHE启示(system管理员执行)
 EXPLAIN plan for
 SELECT /*+ RESULT_CACHE */ department_id,-- 开启了RESULT_CACHE启示
 AVG(salary),COUNT(salary),MIN(salary),MAX(salary)
 FROM hr.employees
 GROUP BY department_id;
 
 set line 300;
 col id for a10;
 col operation for a20;
 col options for a20;
 col object_name for a50;
 -- 从plan_table表获取所解释的SQL语句的执行计划
 SELECT id,operation,options,object_name
 FROM plan_table;
 -- 删除表中全部的内容
 TRUNCATE TABLE plan_table;
 
  -- 使用EXPLANIN plan for 命令解释一个带有分组函数和group by子句的查询语句(system管理员执行)
 EXPLAIN plan for
 SELECT  department_id,
 AVG(salary),COUNT(salary),MIN(salary),MAX(salary)
 FROM hr.employees
 GROUP BY department_id;
 
  set line 300;
 col id for a10;
 col operation for a20;
 col options for a20;
 col object_name for a50;
 -- 从plan_table表获取所解释的SQL语句的执行计划
 SELECT id,operation,options,object_name
 FROM plan_table;
 
 -- 使用软件包DBMS_RESULT_CACHE查询结果内存缓冲区的状态
 col status for a50;
 SELECT DBMS_RESULT_CACHE.STATUS FROM DUAL;
 -- 将依赖于这个表的缓存结果都设置为无效
 EXEC DBMS_RESULT_CACHE.INVALIDATE('HR','EMPLOYEES')
 -- 清空结果内存缓冲
 EXECUTE DBMS_RESULT_CACHE.FLUSH;
 --  获取结果内存缓冲区使用统计信息
 EXECUTE DBMS_RESULT_CACHE.MEMORY_REPORT;
 
 -- 查看DBMS_OUTPUT软件包的状态
 SHOW SERVEROUTPUT;
 -- 设置DBMS_OUTPUT软件包开启
 SET SERVEROUTPUT ON;
 -- 利用数据字典V$RESULT_CACHE_STATISTICS列出各种缓存的设置和内存使用的统计信息
 col id for a30;
 col name for a40;
 col value for a50;
 SELECT * FROM V$RESULT_CACHE_STATISTICS;
 
 /*跨会话的PL/SQL函数结果缓存*/
 -- 创建可以缓存函数结果的函数
 CREATE OR REPLACE FUNCTION emp_hire_date
 (p_emp_id NUMBER) RETURN VARCHAR
 RESULT_CACHE RELIES_ON(emp) IS-- 将函数的结果缓存并返回给调用方
 v_hiredate DATE;
 BEGIN
 SELECT hiredate INTO v_hiredate
 FROM emp
 WHERE empno=p_emp_id;
 RETURN TO_CHAR(v_hiredate);
 END;
 /
 
 -- 执行缓存结果的函数
 SET serveroutput ON;
 BEGIN
 DBMS_OUTPUT.PUT_LINE(emp_hire_date(7369));
 END;
 /
 
 -- 利用V$RESULT_CACHE_OBJECTS列出目前存放在结果缓冲区中的（函数的结果）及（依赖对象）
 col name for a70;
 col status for a30;
 set line  200;
 -- (system管理员登录执行)
 SELECT name,status FROM V$RESULT_CACHE_OBJECTS;
 
 /*以命令行方式获取数据库系统的设计*/
 -- 查询当前用户下所有表和视图
 SELECT * FROM cat;
 -- 查看emp表的结构
 DESC emp;
  -- 查看dept表的结构
 DESC dept;
 
 -- 查看当前用户的约束
 col owner for a10;
 col constraint_name for a20;
 col constraint_type for a10;
 col table_name for a10;
 col R_CONSTRAINT_NAME for a20;
 SELECT owner,constraint_name,constraint_type,table_name,r_constraint_name
 FROM user_constraints;
 
 -- 查看当前用户的约束
 col owner for a10;
 col constraint_name for a20;
 col table_name for a10;
 col column_name for a20;
 SELECT owner,constraint_name,table_name,column_name
 FROM user_cons_columns;
 
-- 查看当前用户索引
col index_name for a20;
col index_type for a10;
col table_name for a10;
col uniqueness for a15;
col tablespace_name for a15;
SELECT INDEX_NAME,INDEX_TYPE,TABLE_NAME,UNIQUENESS,tablespace_name 
FROM user_indexes;

SELECT index_name,table_name,column_name,column_position 
FROM user_ind_columns;


/*导出存储程序的接口参数*/
-- 查看当前用户
show user;
-- 利用数据字典user_objects获取该用户所有的存储过程和函数
col object_name for a15;
SELECT object_name,object_type,created,status,last_ddl_time
FROM user_objects
WHERE object_type IN('PROCEDURE','FUNCTION');
-- 输出过程或函数的结构
DESC GET_EMP_SAL;
-- 利用数据字典user_objects获取该用户所有的软件包和软件包体
col object_name for a15;
SELECT object_name,object_type,created,status,last_ddl_time
FROM user_objects
WHERE object_type IN('PACKAGE','PACKAGE BODY');
-- 查看软件包和软件包体的结构
DESC DEPT_BI;

/*导出存储程序的源代码*/
-- 设置页面显示的行数
SET PAGESIZE 50;
col text for a50;
-- 查看程序的源代码
SELECT line,text
FROM user_source
WHERE name='GET_EMP_SAL';
-- 使用user_source数据字典查询查看源代码
SELECT line,text
FROM user_source
WHERE name='EMP_HIRE_DATE';
-- 使用all_source数据字典查看源代码
SELECT line,text
FROM user_source
WHERE name='SALARY_PKG';
-- 使用user_source数据字典查看源代码
SELECT line,text
FROM all_source
WHERE name='SALARY_PKG';
-- 使用dba_source数据字典查看源代码
SELECT line,text
FROM dba_source
WHERE name='SALARY_PKG';

/*导出触发器的类型、触发事件、描述及源代码*/
-- 利用数据字典user_objects获取该用户所有的触发器
SELECT object_name,object_type,created,status,last_ddl_time
FROM user_objects
WHERE object_type='TRIGGER';
-- 使用数据字典user_triggers来获取该用户下所有的数据库触发器的信息
col trigger_name for a25;
col table_name for a10;
col triggering_event for a30;
SELECT trigger_name,table_name,triggering_event,status
FROM user_triggers;

-- 查看触发器的描述信息
SELECT description
FROM user_triggers
WHERE trigger_name='LOG_EMP_PL';
-- 查看行可容纳的字符数量
SHOW LONG;
-- 设置行可容纳的字符数为32334
SET LONG 32334;
-- 查看触发器的源代码
SELECT trigger_body
FROM user_triggers
WHERE trigger_name='LOG_EMP_PL';

-- 查看数据字典的结构
DESC user_triggers;


/*使用CREATE_WRAPPED过程加密PL/SQL源代码*/
SET serveroutput ON;
-- 创建过程
BEGIN
EXECUTE IMMEDIATE  '
CREATE OR REPLACE  PROCEDURE wuda IS
BEGIN
-- CHR(10)即为换行符
DBMS_OUTPUT.PUT_LINE(''武大驴肉火烧~''||CHR(10)||
                                              ''一个飘香了千年的民族品牌、''||CHR(10)||
											  ''一段流传千古的凄美爱情传奇！！！'');
											  END wuda;
											  ';
END;
/
-- 创建过程
CREATE OR REPLACE PROCEDURE wuda IS
BEGIN
-- CHR(10)即为换行符
DBMS_OUTPUT.PUT_LINE('武大驴肉火烧~'||CHR(10)||
                                              '一个飘香了千年的民族品牌、'||CHR(10)||
											  '一段流传千古的凄美爱情传奇！！！');
											  END wuda;
											  /
-- 调用过程
EXECUTE wuda
-- 调用过程
CALL wuda();

col text for a60;
set line 100;
set pagesize 50;
-- 查看过程的源代码
SELECT line,text
FROM user_source
WHERE name='WUDA';
-- 使用DBMS_DDL软件包的CREATE_WRAPPED过程将存储过程加密
SET serveroutput ON;
BEGIN
DBMS_DDL.CREATE_WRAPPED(
 '
CREATE OR REPLACE  PROCEDURE wuda_wrap IS
BEGIN
-- CHR(10)即为换行符
DBMS_OUTPUT.PUT_LINE(''武大驴肉火烧~''||CHR(10)||
                                              ''一个飘香了千年的民族品牌、''||CHR(10)||
											  ''一段流传千古的凄美爱情传奇！！！'');
											  END wuda_wrap;
											  '
);
END;
/
-- 调用过程
CALL wuda_wrap();
-- 查看过程的源代码
SELECT line,text
FROM user_source
WHERE name='WUDA_WRAP';

-- 利用数据字典查看存储过程信息
SELECT object_name,object_type,created,status,last_ddl_time
FROM user_objects
WHERE object_name LIKE 'WUDA%';

/*使用CREATE_WRAPPED过程加密较长的代码*/
DECLARE
-- 声明一个字符串常量存放软件包、过程或函数的源代码
c_code CONSTANT VARCHAR2(32767):=
'CREATE OR REPLACE  PACKAGE BODY employee_dog IS
PROCEDURE get_emp(p_emps OUT emp_table_type) IS
v_count BINARY_INTEGER:=0;
BEGIN
FOR emp_record IN (SELECT * FROM emp)
LOOP
p_emps(v_count):=emp_record;
v_count:=v_count+1;
END LOOP;
END get_emp;
END employee_dog;
';
BEGIN
-- 动态加密软件包、过程或函数
DBMS_DDL.CREATE_WRAPPED(c_code);
END;
/

-- 设置DBMS_OUTPUT软件包开启
SET serveroutput ON;
DECLARE
-- 声明一个INDEX BY记录表数据类型是软件包的变量
employees employee_dog.emp_table_type;
BEGIN
-- 执行软件包
employee_dog.get_emp(employees);
DBMS_OUTPUT.PUT_LINE('Emp 8:'||employees(8).ename||' '||employees(8).job||' '||employees(8).sal);
END;
/

-- 查看软件包的源代码
col line for a40;
col text for a80;
SELECT line,text
FROM user_source
WHERE name='EMPLOYEE_DOG'
ORDER BY line;

/*使用命令行加密SQL文件*/
-- 打开运行窗口
Win+R
-- 打开cmd窗口
cmd
-- 切换到指定目录
cd C:\Users\cao\Desktop
-- 列出带emp的文件和文件夹
dir emp*
-- 对指定文件中的源代码加密成另一个同名但格式不同的文件
wrap iname=employee_dog.sql
-- 对指定文件中的源代码加密成另一个指定的文件
wrap iname=employee_dog oname=emp.sql
-- 运行加密后的源代码文件（打开SQL*PLUS登录用户后执行）
@C:\Users\cao\Desktop\employee_pkg.plb
-- 查看软件包的源代码
col line for a40;
col text for a80;
SELECT line,text
FROM user_source
WHERE name='EMPLOYEE_DOG'
ORDER BY line;

/*导出数据的SQL语法*/
SET line 1200;
SET serveroutput ON;
SET verify OFF;
DECLARE
v_name VARCHAR2(30):='&p_name';
-- 创建column_cursor
CURSOR column_cursor IS
SELECT column_name
FROM user_col_comments WHERE table_name=v_name;
-- 创建cursor变量
data_cursor SYS_REFCURSOR;
v_sql VARCHAR2(200):='SELECT * FROM '||v_name;
v_column_name VARCHAR2(500):='';
data_record serial_number%ROWTYPE;
BEGIN
FOR column_record IN column_cursor LOOP
v_column_name:=v_column_name||column_record.column_name||',';
END LOOP;
v_column_name:=substr(v_column_name,1,length(v_column_name)-1);
DBMS_OUTPUT.PUT_LINE(v_column_name);
-- 设置cursor的SQL语法并打开cursor
OPEN data_cursor FOR v_sql;
LOOP
FETCH data_cursor INTO data_record;
-- 当cursor里面没有记录或者cursor是空的则退出循环
EXIT WHEN data_cursor%NOTFOUND or data_cursor%NOTFOUND IS NULL;
DBMS_OUTPUT.PUT_LINE('insert into '||lower(v_name)||'('||lower(v_column_name)||') values ('||
''''||data_record.serial_number_id||''''||','||
''''||data_record.mo_id||''''||','||
''''||data_record.product_id||''''||','||
'to_date('||''''||to_char(data_record.create_date,'YYYY-MM-DD hh24:mi:ss')||''''||','||''''||'YYYY-MM-DD hh24:mi:ss'||''''||'),'||
''''||data_record.years||''''||','||
''''||data_record.begin_no||''''||','||
''''||data_record.end_no||''''||','||
''''||data_record.version||''''||','||
'to_date('||''''||to_char(data_record.modify_date,'YYYY-MM-DD hh24:mi:ss')||''''||','||''''||'YYYY-MM-DD hh24:mi:ss'||''''||'),'||
''''||data_record.orders||''''||','||
''''||data_record.years_and_weeks||''''||','||
''''||data_record.period||''''||','||
''''||data_record.week||''''||');');
END LOOP;
CLOSE data_cursor;
END;
/
col table_name for a20;
col column_name for a20;
col comments for a30;
select * from user_col_comments where table_name='SERIAL_NUMBER';


/**********************************自己编写的例子*************************************************************/
-- 输出字符串
set serveroutput on;
declare
v_name varchar2(30):='abc';
v_str varchar2(30):='abc';
begin
if v_name=v_str then
dbms_output.put_line(v_name);
end if;
end;

select processno from sfs.floormaster where processno like 'Z2J3105%' and processid='3' order by processno;

set serveroutput on;
DECLARE
-- 声明一个INDEX BY记录表
TYPE floormaster_table_type IS TABLE OF sfs.floormaster%ROWTYPE 
INDEX BY PLS_INTEGER;
floormaster_table floormaster_table_type;
-- 声明一个INDEX BY表
TYPE f_table_type IS TABLE OF VARCHAR2(60)
INDEX BY PLS_INTEGER;
f_table f_table_type;
--声明一个cursor
CURSOR floormaster_cursor IS SELECT ROWNUM,processno
FROM sfs.floormaster 
where processno like 'Z2J3105%' and processid='3';
BEGIN
FOR floormaster_rec IN floormaster_cursor LOOP
--DBMS_OUTPUT.PUT_LINE(floormaster_rec.rownum||','||floormaster_rec.processno);
floormaster_table(floormaster_rec.rownum).processno:=floormaster_rec.processno;
END LOOP;
FOR i IN 1.. 660 LOOP

END LOOP;
END;


sql*plus的dba登陆
在sql*plus的工具里不能用dba的身份登陆，只能用user/password ,db名称来登陆
后来在dos下，用如下命令即可：
sqlplus /nolog
  conn sys/syspassword as sysdba

  --删除用户连接数
  alter system kill session 'sid,serial#';

  -- 添加禁用機種
SET verify OFF
SET serveroutput ON
DECLARE
TYPE product_table_type IS TABLE OF
VARCHAR(100);
product_table product_table_type:=product_table_type('KA7170-AX','KA7570-AX','KA7970-AX','KA7920-AX','US3344-AT','US434-AT','US434-EL','US434-RL','US434-RW','US434-ST','US3324-AT','US234-EL','US234-MN','US234-RL','US234-RW','UE350A-AT','GUE305','UC2324-AT','UC2322-AT','UC4852-AT','UC4854-AT','UC2324-CO');
v_count NUMBER:=1;
i NUMBER:=product_table.FIRST;
v_company VARCHAR2(10):='01';
v_productid VARCHAR2(40);
v_status VARCHAR2(10):='Y';
v_createdate VARCHAR2(30):=to_char(sysdate,'yy-MM-dd');
v_createtime VARCHAR2(30):=to_char(sysdate,'hh24:mi:ss');
v_user VARCHAR2(30):='系統開發者';
BEGIN
WHILE i IS NOT NULL LOOP
SELECT count(*) INTO v_count FROM sfs.rta_product WHERE productid=product_table(i);
IF v_count>0 THEN
UPDATE sfs.rta_product SET status=v_status,createtime=v_createtime WHERE productid=product_table(i);
ELSE
INSERT INTO sfs.rta_product VALUES (v_company,product_table(i),v_status,v_createdate,v_createtime,v_user);
END IF;
i:=product_table.NEXT(i);
END LOOP;
END;
/

-- 創建fixed_code_seq序列
CREATE SEQUENCE fixed_code_seq
MINVALUE 1 -- 最小值
MAXVALUE 999999999999 --最大值
START WITH 1 --從哪裏開始
INCREMENT BY 1 -- 每次加幾個
CACHE 20 --緩存值多少

-- 查看角色
SELECT * FROM sfs.role;
-- 為系統組裝部賬號設置作業員角色
SET verify OFF;
SET serveroutput ON;
DECLARE
v_count NUMBER;
v_role_id VARCHAR2(10):='8';-- 作業員角色ID
CURSOR user_cursor IS
-- 系統組裝部賬號
SELECT * FROM sfs.user_info WHERE dept='02';
BEGIN
FOR user_record IN user_cursor LOOP
SELECT count(*) INTO v_count FROM SFS.user_role 
WHERE user_id=user_record.user_id;
IF v_count>0 THEN
DBMS_OUTPUT.PUT_LINE(v_count);
ELSE
INSERT INTO sfs.user_role VALUES (user_record.user_id,v_role_id,'A',to_char(add_months(sysdate,12*10),'yyyy-MM-dd hh24:mi:ss'));
DBMS_OUTPUT.PUT_LINE(user_record.user_name||','||user_record.user_id);
END IF;
END LOOP;
END;

-- 刪除IN110和DL150數據
SET verify OFF;
SET serveroutput ON;
DECLARE
v_serialNo VARCHAR2(30):='Z3K30910005';-- 製程序號
v_moid VARCHAR2(10):='Z3K3091';-- 工單
CURSOR serialnumber_cursor IS
SELECT processno FROM sfs.serialnumber
WHERE processno LIKE v_moid||'%' AND processno>v_serialNo;
BEGIN
FOR serial_record IN serialnumber_cursor LOOP
BEGIN-- 在循環中捕獲異常
DELETE FROM sfs.floordetail WHERE floorid LIKE serial_record.processno||'%';
DELETE FROM sfs.floormaster WHERE processno=serial_record.processno;
DELETE FROM SFS.serialnumber_detail WHERE moid=v_moid AND processno=serial_record.processno;
DELETE FROM sfs.serialnumber WHERE processno=serial_record.processno;
DELETE FROM sfs.processno_mapping WHERE processno=serial_record.processno;
DBMS_OUTPUT.PUT_LINE(serial_record.processno);
RAISE_APPLICATION_ERROR(-02292,'發現子項記錄');-- 抛出異常
EXCEPTION
WHEN others THEN-- 捕獲異常
-- DBMS_OUTPUT.PUT_LINE('錯誤，發現子項記錄：'||serial_record.processno);
END;
END LOOP;-- 隐含关闭cursor
END;

SET SERVEROUTPUT ON;
DECLARE
v_moid VARCHAR2(10):='Z3L7180';
v_sapwork VARCHAR2(6):='0140';
v_processid VARCHAR2(3):='8';
-- 聲明CURSOR
CURSOR wh_list IS
SELECT substr(floorid,1,7) moid,substr(min(processno),1,8) begindate,min(floortime) begintime,
substr(max(processno),1,8) enddate,max(floortime) endtime
FROM sfs.floordetail1 WHERE floorid 
IN (SELECT floorid FROM sfs.floormaster1 WHERE sapwork='0140' AND moid='Z3L7180') GROUP BY floorid;
TYPE floormaster_table_type IS TABLE OF sfs.floormaster%ROWTYPE;
floormaster_type floormaster_table_type;
BEGIN
--遍歷CURSOR
FOR wh_record IN wh_list LOOP
-- 將多條記錄添加到INDEX BY記錄表
SELECT * BULK COLLECT INTO floormaster_type FROM sfs.floormaster 
WHERE processid=v_processid  AND floordate>=wh_record.begindate AND floortime>=wh_record.begintime 
AND endtime<=wh_record.endtime AND processno LIKE v_moid||'%';
DBMS_OUTPUT.PUT_LINE(wh_record.moid||';'||wh_record.begindate||';'||wh_record.begintime||';'||wh_record.enddate||';'||wh_record.endtime||';'||floormaster_type.COUNT);
-- 遍歷INDEX BY記錄表
FOR i IN 1 .. floormaster_type.COUNT LOOP
DBMS_OUTPUT.PUT_LINE(floormaster_type(i).processno||' '||floormaster_type(i).userid||' '||floormaster_type(i).status||' '||floormaster_type(i).nextprocessid);
END LOOP;
END LOOP;
END;

SET verify OFF
SET serveroutput ON
DECLARE
TYPE semi_finished_print_table_type IS TABLE OF sfs.semi_finished_print%ROWTYPE 
INDEX BY PLS_INTEGER;
semi_finished_print_table semi_finished_print_table_type;
v_j NUMBER(3);
BEGIN
semi_finished_print_table(1).processno:='A1L93310001';
v_j:=semi_finished_print_table.FIRST;
WHILE v_j IS NOT NULL LOOP
DBMS_OUTPUT.PUT_LINE(semi_finished_print_table(v_j).processno);
v_j:=semi_finished_print_table.NEXT(v_j);
END LOOP;
END;

-- 換頭作業工單設置DL150數量上傳（換頭前和換頭後的工單都爲Z3時）
SET verify OFF;
SET serveroutput ON;
DECLARE
v_moid VARCHAR2(10):='Z3L9213';--工單
v_ver VARCHAR2(6):='FA';--版本
CURSOR productnos IS 
SELECT substr(floorid,1,11) processno,mark 
FROM SFS.floordetail WHERE markstypeid='0' AND floorid LIKE v_moid||'%';
BEGIN
FOR productno_record IN productnos LOOP
UPDATE SFS.serialnumber 
SET productno=productno_record.mark,fgver='FA',productdate=to_char(sysdate,'yyyyMMddhh24miss') 
WHERE processno=productno_record.processno;
DBMS_OUTPUT.PUT_LINE(productno_record.processno);
END LOOP;
END;

SET verify OFF;
SET serveroutput ON;
DECLARE
v_moid VARCHAR2(10):='Z3LB028';--工單
v_ver VARCHAR2(6):='D3';--版本
CURSOR productnos IS 
SELECT 'Z3LB-028-'||lpad(ROWNUM,4,'0') productno,processno
FROM SFS.serialnumber WHERE processno LIKE v_moid||'%';
BEGIN
FOR productno_record IN productnos LOOP
UPDATE SFS.serialnumber 
SET productno=productno_record.productno,fgver=v_ver,productdate=to_char(sysdate,'yyyyMMddhh24miss'),nextprocessid='9',nextgroup='04',
priorprocessid='9',priorgroup='03'
WHERE processno=productno_record.processno;
DBMS_OUTPUT.PUT_LINE(productno_record.processno);
END LOOP;
END;