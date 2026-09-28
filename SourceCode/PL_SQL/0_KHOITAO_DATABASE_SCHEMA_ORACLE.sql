-- ############################# HỌC SQL ORACLE CƠ BẢN ###################################

-- =================================================================================================
/* ## I - NHÓM LỆNH TẠO DATABASE (SCHEMA ~ USER)(TƯƠNG ỨNG DATABASE TRONG MYSQL, SQLSERVER)##*/
-- =================================================================================================
    /* -- lƯU ý: trong mysql, sqlserver.. thì khái niệm này là create, use database, hệ sinh thái 
    Oracle thì không dùng khái niêm database kiểu dậy mà nó dùng hệ sinh thái schema ~ user 
    thường user mặc định khi tọa schema(create new connection á) là system 
     <=> tuy nhiên system lại chứa table, view, procedure mẫu làm lẫn lộn với table bạn tạo 
     ==> nên để khắc phục điều đó ta cần khai báo cấu hình user mới thay vì dùng user mặc 
     định là system của Oracle khi tạo connection mới 
     ==> sau đây là các lệnh thực hiện công việc đó*/
    -- Lệnh này cực kỳ quan trọng cho bản Oracle 12c, 19c, 21c... 
    -- Nó cho phép bạn tạo user tên đơn giản (không cần có chữ C## phía trước)
    
    -- 1/ Tạo Tablespace (vùng không gian lưu trữ) - LƯU Ý TÊN TABLESPACE VÀ FILE.DBF DO MÌNH ĐẶT
    CREATE TABLESPACE TS_QUANLY
    DATAFILE 'E:\PRATICE_CODE\ERP_ENGINEERS\SourceCode\DBF\quanly_data1.dbf'
    SIZE 50M
    AUTOEXTEND ON NEXT 10M;
    
    --2/ Cho phép tạo user kiểu đơn giản (local user)
    ALTER SESSION SET "_ORACLE_SCRIPT" = true;
    
    -- 3/  Tạo User (Khai sinh Schema ~ USER mới)
    -- Mật khẩu có ký tự đặc biệt như @, #, $ PHẢI để trong dấu ""
    /* >> trong đó: 
         + IDENTIFIED là thiết lặp mật khẩu mới cho user vừa mới tạo
         + DEFAULT TABLESPACE <TÊN TABLESPACE> Chỉ định vùng lưu trữ dữ liệu mặc 
		 định cho User. Nếu không có chỉ định nó sẽ ném values thật vào tablespace 
   		 mặc định là system..
		 + QUOTA UNLIMITED ON TS_QUANLY: Cấp quyền sử dụng dung lượng không giới 
		 hạn trên vùng lưu trữ đó. Quota chính là mức dung lượng, Unlimited là không 
         giới hạn*/
    CREATE USER PHUC_LEARNING 
    IDENTIFIED BY "Huuphuc1995ct@"
    DEFAULT TABLESPACE TS_QUANLY
    QUOTA UNLIMITED ON TS_QUANLY;
    
    
    -- 4/ Cấp các quyền cơ bản để user này có thể làm việc
        -- CONNECT: Quyền đi vào cửa.
        -- RESOURCE: Quyền xây bảng, thêm dữ liệu.
        -- UNLIMITED TABLESPACE: Quyền dùng đất (không gian lưu trữ).
    GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO PHUC_LEARNING;
    
    /*==> sau khi tạo user mới thì tiếp tục tạo new connection(dấu + hay r-click vào oracle connection)
     để tiến hành "THIẾT LẬP KẾT NỐI TRÊN ORACLE SQL DEVELOPER (GUI) VỚI USER MỚI TẠO"
       - Mở Oracle SQL Developer.
       - Tại cửa sổ "Connections", chuột phải chọn "New Connection" (hoặc bấm dấu +).
       - Điền thông tin:
        + Name: Ten_Ket_Noi (Tùy chọn, ví dụ: Connection_Phuc)
        + Username: User_Phuc (Tên user vừa tạo ở trên)
        + Password: 123456
        + Hostname: localhost (hoặc IP server)
        + Port: 1521 (Mặc định)
        + SID hoặc Service Name: Thường là 'xe' (bản Express) hoặc 'orcl'.
       - Bấm "Test" để kiểm tra, nếu báo "Success" thì chọn "Connect".
    */
    
    /* ##NOTE##
     => lưu ý là với Oracle không có use database mà muốn đổi database(là một connection vừa tạo bằng cách bấm dấu 
     + hay r-click new connection của oracle connection á) thì mình nhìn gốc trên cùng bên phải mà select chọn 
     database cho đúng là xong
    */
    
    
    
    
    
-- ======================================================================================================
/* ## II -TẠO MỚI MỘT (SCHEMA ~ USER)(TƯƠNG ỨNG DATABASE TRONG MYSQL, SQLSERVER) CHO VIỆC HỌC OJT R2S##
 (User này dùng cho các connection database dùng cho khóa học OJT R2S BE JAVA)*/
-- ======================================================================================================

-- #### Tạo User (Khai sinh Schema ~ USER mới cho connection tên Sales)####
    --> Cho phép tạo user kiểu đơn giản (local user)
    ALTER SESSION SET "_ORACLE_SCRIPT" = true;
    
    CREATE USER SALES_OJT_R2S 
    IDENTIFIED BY "Huuphuc1995ct@"
    DEFAULT TABLESPACE TS_QUANLY
    QUOTA UNLIMITED ON TS_QUANLY;
    
    -- > Cấp các quyền cơ bản để user này có thể làm việc    
    GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO SALES_OJT_R2S;
    
    
    
    
-- ##### Tạo User (Khai sinh Schema ~ USER mới cho connection tên BikeStores)####

    --> Cho phép tạo user kiểu đơn giản (local user)
    ALTER SESSION SET "_ORACLE_SCRIPT" = true;
    
    CREATE USER BIKESTORE_OJT_R2S 
    IDENTIFIED BY "Huuphuc1995ct@"
    DEFAULT TABLESPACE TS_QUANLY
    QUOTA UNLIMITED ON TS_QUANLY;
    
    -- > Cấp các quyền cơ bản để user này có thể làm việc    
    GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO BIKESTORE_OJT_R2S;
    



    
-- ##### Tạo User (Khai sinh Schema ~ USER mới cho connection tên JDBC_OJT_R2S)####

    --> Cho phép tạo user kiểu đơn giản (local user)
    ALTER SESSION SET "_ORACLE_SCRIPT" = true;
    
    CREATE USER JDBC_OJT_R2S 
    IDENTIFIED BY "Huuphuc1995ct@"
    DEFAULT TABLESPACE TS_QUANLY
    QUOTA UNLIMITED ON TS_QUANLY;
    
    -- > Cấp các quyền cơ bản để user này có thể làm việc    
    GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO JDBC_OJT_R2S;
    


-- =============================================================================================================
/*III - */
-- =============================================================================================================

