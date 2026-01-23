resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.name}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

# -------- Subnets públicas (ALB + NAT) ----------
resource "aws_subnet" "public" {
  for_each = { for i, cidr in var.public_subnet_cidrs : i => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-public-${var.azs[tonumber(each.key)]}"
    Tier = "public"
  })
}

# -------- Subnets privadas APP (ECS) ----------
resource "aws_subnet" "private_app" {
  for_each = { for i, cidr in var.private_app_subnet_cidrs : i => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-private-app-${var.azs[tonumber(each.key)]}"
    Tier = "private-app"
  })
}

# -------- Subnets privadas DB (RDS) ----------
resource "aws_subnet" "private_db" {
  for_each = { for i, cidr in var.private_db_subnet_cidrs : i => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name}-private-db-${var.azs[tonumber(each.key)]}"
    Tier = "private-db"
  })
}

# -------- Route tables ----------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-rt-public" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

# -------- NAT Gateway (opcional) ----------
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0
  domain = "vpc"

  tags = merge(var.tags, { Name = "${var.name}-eip-nat-${count.index}" })
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = values(aws_subnet.public)[var.single_nat_gateway ? 0 : count.index].id

  tags = merge(var.tags, { Name = "${var.name}-nat-${count.index}" })

  depends_on = [aws_internet_gateway.this]
}

# RT privadas APP (com rota pro NAT)
resource "aws_route_table" "private_app" {
  for_each = aws_subnet.private_app

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-rt-private-app-${each.key}"
  })
}

resource "aws_route" "private_app_default" {
  for_each = var.enable_nat_gateway ? aws_route_table.private_app : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[var.single_nat_gateway ? 0 : tonumber(each.key)].id
}

resource "aws_route_table_association" "private_app" {
  for_each       = aws_subnet.private_app
  route_table_id = aws_route_table.private_app[each.key].id
  subnet_id      = each.value.id
}

# RT privadas DB (SEM rota default por padrão)
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-rt-private-db" })
}

resource "aws_route_table_association" "private_db" {
  for_each       = aws_subnet.private_db
  route_table_id = aws_route_table.private_db.id
  subnet_id      = each.value.id
}
