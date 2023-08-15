-- Criação de banco de dados para o cenário E-Comerce
create database ecommerce_desafio;
use ecommerce_desafio;


-- Criação de tabela cliente
create	table Clients(
	idClient int auto_increment primary key,
	Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
	Address varchar(30),
    TipyClient enum('PJ','PF') not null default 'PF',
    constraint unique_cpf_client unique (CPF)
);

-- desc Clients;
-- drop table Product;
-- Criação de Produto
create	table Product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    Classification_kids bool default false,
    Category enum('Eletronico','Vestimenta','Brinquedo', 'Alimentos','Móveis') not null ,
    Avaliação float default 0,
    Size varchar(10)    
);
-- desc Product;


-- Criação tabela pedido
create	table Orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    OrderStatus enum('Cancelado','Confirmado','Em Processamento') default 'Em processamento',
    OrderDescription varchar(255),
    SendValue float default 10,
    PaymentCash bool default false,
    constraint fk_ordes_client foreign key(idOrderClient) references Clients(idClient)
    on update cascade
    on delete set null
    );
-- desc Orders;

-- criar tabela estoque
create table ProductStorage(
	idProdStorage int auto_increment primary key,
    StorageLocation varchar(255),
    Quantity int default 0
);
alter table productStorage auto_increment=1;
     
     
     -- Criação tabela de pagamento
create	table Payments(
	idClient int ,
    idPayment int,
    typePayment enum('boleto','Cartão','Dois Cartões'),
    Pay_Card enum('Debit','Credit') default 'Debit',
    limitAvailable float,
    primary key (idClient, idPayment) 
     
);

-- Criação tabela Estoque relacionamento N:M
create table StorageLocation(
	idLproduct int,
    idLstorage int,
    Location varchar(255) not null,
	Quantity int,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
    );
    
-- Criação tabela fornecedor
create	table Supplier(
	idSuppler int auto_increment primary key,
    SocialName char(15) not null,
    CNPJ char(15) not null,
    Contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
    
    );
-- desc Supplier;
    
    
-- Criação tabela vendedor
create	table Seller(
	idSeller int auto_increment primary key,
    SocialName varchar(225) not null,
    AbstName varchar(225),
    Location varchar(225),
    CNPJ char(15) ,
    CPF char(9) ,
    Contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_supplier unique (CPF)    
    );
    

create table productOrder(
	idPOproduct int,
    idPOorder int,
    idDelivery int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder,idDelivery),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)
    );
    
    
-- Criação tabela terceiros
create	table ProductSeller(
	idPSeller int,
    idPproduct int,
    ProdQuantity int default 1,
    primary key (idPSeller,idPproduct),
    constraint fk_product_seller foreign key(idPSeller) references Seller(idSeller),
    constraint fk_product_product foreign key(idPproduct) references Product(idProduct)
);
desc ProductSeller;


create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references Supplier(idSuppler),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references Product(idProduct)
);




   -- Quantos pedidos foram feitos por cada cliente?
 SELECT c.CPF, COUNT(o.idOrders) AS Quantidade_de_Pedido
FROM Cliente c
JOIN Orders o ON c.CPF = o.CPF_cliente
GROUP BY c.CPF;
   
   -- Algum vendedor também é fornecedor?
SELECT s.SocialName, (CASE WHEN s.CNPJ=se.CNPJ THEN 'yes' ELSE 'no' END) AS Supplier_E_Seller
FROM Supplier s, Seller se
JOIN Supplier s ON v.CPF = s.CPF;   
   
	-- Relação de produtos fornecedores e estoques;
SELECT p.ProductName, s.SupplierName, l.Quantity
FROM Products p, Supplier s, StorageLocation l
JOIN Suppliers s ON p.SupplierID = s.SupplierID
JOIN StorageLocation l ON p.ProductID = st.ProductID;
    
    -- Relação de nomes dos fornecedores e nomes dos produtos;
SELECT p.Pname AS Produto, s.SocialName AS Fornecedor
FROM Product p, Supplier s
where idSuppler = idProduct

