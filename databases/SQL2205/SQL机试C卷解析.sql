----------------------------------	SQL机试C卷---------------------------------------------------------



select * from 成绩表;

create table 成绩表
(
	oid int identity(1,1) primary key,
	name varchar(20) not null,
	kecheng varchar(20) not null,
	fenshu int 
)


truncate table 成绩表

insert into  成绩表 values('张三','语文',81);
insert into  成绩表 values('张三','数学',59);
insert into  成绩表 values('李四','语文',99);
insert into  成绩表 values('李四','数学',90);
insert into  成绩表 values('王五','语文',56);
insert into  成绩表 values('王五','数学',30);
insert into  成绩表 values('王五','英语',90);
truncate 
select * from 成绩表 where kecheng='语文' and fenshu<80
select * from 成绩表 where kecheng='数学' and fenshu<60


--语文80分以下的加10分,数学不及格的改为60分
declare @kecheng varchar(20),@fenshu int
	declare cur cursor for select kecheng,fenshu from 成绩表
	open cur 
	fetch next from cur into @kecheng,@fenshu
	while @@fetch_status=0
	begin
		if @kecheng='语文' and @fenshu<80
		begin
			update 成绩表 set fenshu=fenshu+10 where current of cur
		end
		else if @kecheng='数学' and @fenshu<60
		begin
			update 成绩表 set fenshu=60 where current of cur
		end
		fetch next from cur into @kecheng,@fenshu
	end
	close cur
	deallocate cur




--写一个自动编号的存储过程，如:201703180001? 
alter table orderss(orderid varchar(12) primary key)

select * from orderss;
delete orderss top 15
insert into orderss values('201703180001')
alter procedure up_orderid2
as
	declare @str varchar(12)
	declare @cnt varchar(4)
	select @str=convert(varchar(8),getdate(),112);
	select @cnt = count(*)+1 from orderss where orderid like @str+'%'
--	if @cnt<10
--	begin
--		set @str = @str + '000'+ convert(varchar(1),@cnt)
--	end
--	else if @cnt<100 and @cnt>=10
--	begin
--		set @str = @str + '00'+ convert(varchar(2),@cnt)
--	end
--	else if @cnt<1000 and @cnt>=100
--	begin
--		set @str = @str + '0'+ convert(varchar(3),@cnt)
--	end
--	else
--	begin
--		select @cnt
--		select 4-len(@cnt)
--		select convert(varchar(4),replicate('0',4-len(@cnt))+convert(varchar(4),@cnt))
		set @str =@str+ convert(varchar(4),replicate('0',4-len(@cnt))+@cnt)
--		select archar(4),replicate('0',4-len(@cnt))
--	end
	insert into orderss values(@str);
	select @str
go
select convert(varchar(4),replicate('0',4-len('hel'))+1)
select len('hellow')

up_orderid2

select * from orderss;

drop procedure up_orderid2
------------------------------------
alter procedure up_orderid2
as
	declare @str varchar(12)
	declare @cnt int
	SELECT @CNT=1
	declare @string varchar(12)
	SET @STRING=''
	select @str=convert(varchar(8),getdate(),112);
	set @str =@str+ convert(varchar(4),replicate('0',4-len(@cnt))+convert(varchar(4),@cnt))
	select @str
	set @cnt=@cnt+1
	set @string =@string+ convert(varchar(8),getdate(),112)+convert(varchar(4),replicate('0',4-len(@cnt))+convert(varchar(4),@cnt))
	update orderss set orderid=@string WHERE ORDERID=@str

go
select convert(varchar(4),replicate('0',4-len('hel'))+1)
select len('hellow')

up_orderid2





--编写一个过程，计算某个月有多少天
create proc calcDay
	@year varchar(4),
	@month varchar(2),
	@day int output
as
	declare @date varchar(20)
	set @date = @year+'-'+@month+'-01'
	select @day=datepart(dd,dateadd(ms,-3,dateadd(mm,1,@date)));

go

declare @day int
exec calcday '2008','2',@day output;
select @day





--1.触发器实现有学生的班级不能删除
select * from classes;

create trigger delclass on classes for delete
as
	if (select count(*) from stud where classid=(select classid from deleted))>0
	begin
		print '该班有学生，不能删除'
		rollback transaction
	end
	else
		print '删除成功'
go

drop trigger delClass;

delete classes where classid=4;





--2.触发器实现当插入、删除学生时修改班级表中对应班级的人数
select * from classes;
select * from stud;


create trigger studAdd on stud for insert,delete
as
	declare @classid int
	set @classid=0
	select @classid=classid from inserted
	if @classid>0
	begin
		declare cur cursor for select classid from inserted
		open cur
		fetch next from cur into @classid
		while @@fetch_status=0
		begin
			update classes set studcnt=studcnt+1 where classid=@classid
			fetch next from cur into @classid
		end	
		close cur
		deallocate cur
	end
	if @classid<=0
	begin
		declare cur cursor for select classid from deleted
		open cur
		fetch next from cur into @classid
		while @@fetch_status=0
		begin
			update classes set studcnt=studcnt-1 where classid=@classid
			fetch next from cur into @classid
		end
		close cur
		deallocate cur
	end
go

delete stud where studid=1008
select * from classes;
select *  from stud order by classid;


drop trigger studAdd;
