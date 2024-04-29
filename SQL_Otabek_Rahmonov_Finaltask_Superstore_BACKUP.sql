--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: data_mart; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA data_mart;


ALTER SCHEMA data_mart OWNER TO postgres;

--
-- Name: increase_order_quantity(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.increase_order_quantity() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Orders
    SET Quantity = Quantity + 1;
END;
$$;


ALTER FUNCTION public.increase_order_quantity() OWNER TO postgres;

--
-- Name: update_category(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_category(category_id integer, new_category_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE categories
    SET categoryname = new_category_name
    WHERE categoryid = category_id;
END;
$$;


ALTER FUNCTION public.update_category(category_id integer, new_category_name character varying) OWNER TO postgres;

--
-- Name: update_city(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_city(city_id integer, new_city_name character varying, new_state_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE cities
    SET cityname = new_city_name,
        stateid = new_state_id
    WHERE cityid = city_id;
END;
$$;


ALTER FUNCTION public.update_city(city_id integer, new_city_name character varying, new_state_id integer) OWNER TO postgres;

--
-- Name: update_country(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_country(country_id integer, new_country_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE countries
    SET countryname = new_country_name
    WHERE countryid = country_id;
END;
$$;


ALTER FUNCTION public.update_country(country_id integer, new_country_name character varying) OWNER TO postgres;

--
-- Name: update_segment(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_segment(segment_id integer, new_segment_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE segments
    SET segmentname = new_segment_name
    WHERE segmentid = segment_id;
END;
$$;


ALTER FUNCTION public.update_segment(segment_id integer, new_segment_name character varying) OWNER TO postgres;

--
-- Name: update_state(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_state(state_id integer, new_state_name character varying, new_region_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE states
    SET statename = new_state_name,
        regionid = new_region_id
    WHERE stateid = state_id;
END;
$$;


ALTER FUNCTION public.update_state(state_id integer, new_state_name character varying, new_region_id integer) OWNER TO postgres;

--
-- Name: update_subcategory(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_subcategory(subcategory_id integer, new_subcategory_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE subcategories
    SET subcategoryname = new_subcategory_name
    WHERE subcategoryid = subcategory_id;
END;
$$;


ALTER FUNCTION public.update_subcategory(subcategory_id integer, new_subcategory_name character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: denormalized_data_mart; Type: TABLE; Schema: data_mart; Owner: postgres
--

CREATE TABLE data_mart.denormalized_data_mart (
    countryname character varying(255),
    statename character varying(255),
    cityname character varying(255),
    regionname character varying(255),
    categoryname character varying(255),
    subcategoryname character varying(255),
    productname character varying(255),
    customername character varying(255),
    segmentname character varying(255),
    orderdate date,
    shipdate date,
    shipmode character varying(255),
    sales numeric(10,2),
    quantity integer,
    profit numeric(10,4)
);


ALTER TABLE data_mart.denormalized_data_mart OWNER TO postgres;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    categoryid integer NOT NULL,
    categoryname character varying(255)
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ALTER COLUMN categoryid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categories_categoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    orderid character varying(255) NOT NULL,
    orderdate date,
    shipdate date,
    shipmode character varying(255),
    customerid character varying(255),
    sales numeric(10,2),
    quantity integer,
    profit numeric(10,4)
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    productid character varying(255) NOT NULL,
    categoryid integer,
    subcategoryid integer,
    productname character varying(255)
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: shipments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipments (
    shipmentid integer NOT NULL,
    orderid character varying,
    productid character varying(255),
    shipdate date,
    shipmode character varying(255),
    quantity integer
);


ALTER TABLE public.shipments OWNER TO postgres;

--
-- Name: category_sales_profit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.category_sales_profit AS
 SELECT c.categoryname,
    sum(o.sales) AS totalsales,
    sum(o.profit) AS totalprofit
   FROM (((public.orders o
     JOIN public.shipments s ON (((o.orderid)::text = (s.orderid)::text)))
     JOIN public.products p ON (((s.productid)::text = (p.productid)::text)))
     JOIN public.categories c ON ((p.categoryid = c.categoryid)))
  GROUP BY c.categoryname;


ALTER TABLE public.category_sales_profit OWNER TO postgres;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    cityid integer NOT NULL,
    cityname character varying(255),
    stateid integer
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: cities_cityid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cities ALTER COLUMN cityid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cities_cityid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    countryid integer NOT NULL,
    countryname character varying(255)
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_countryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.countries ALTER COLUMN countryid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.countries_countryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customerid character varying(255) NOT NULL,
    customername character varying(255),
    segmentid integer,
    countryid integer,
    stateid integer,
    cityid integer
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: segments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.segments (
    segmentid integer NOT NULL,
    segmentname character varying(255)
);


ALTER TABLE public.segments OWNER TO postgres;

--
-- Name: states; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.states (
    stateid integer NOT NULL,
    statename character varying(255),
    regionid integer
);


ALTER TABLE public.states OWNER TO postgres;

--
-- Name: order_customer_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.order_customer_details AS
 SELECT o.orderid,
    o.orderdate,
    o.shipdate,
    o.shipmode,
    c.customerid,
    c.customername,
    s.segmentname,
    co.countryname,
    st.statename,
    ci.cityname
   FROM (((((public.orders o
     JOIN public.customers c ON (((o.customerid)::text = (c.customerid)::text)))
     JOIN public.segments s ON ((c.segmentid = s.segmentid)))
     JOIN public.countries co ON ((c.countryid = co.countryid)))
     JOIN public.states st ON ((c.stateid = st.stateid)))
     JOIN public.cities ci ON ((c.cityid = ci.cityid)));


ALTER TABLE public.order_customer_details OWNER TO postgres;

--
-- Name: recent_quarter_analytics; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.recent_quarter_analytics AS
 SELECT date_trunc('quarter'::text, (o.orderdate)::timestamp with time zone) AS quarter_start_date,
    sum(o.sales) AS total_sales,
    avg(o.profit) AS average_profit
   FROM public.orders o
  WHERE (date_trunc('quarter'::text, (o.orderdate)::timestamp with time zone) = ( SELECT date_trunc('quarter'::text, (max(orders.orderdate))::timestamp with time zone) AS date_trunc
           FROM public.orders))
  GROUP BY (date_trunc('quarter'::text, (o.orderdate)::timestamp with time zone));


ALTER TABLE public.recent_quarter_analytics OWNER TO postgres;

--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    regionid integer NOT NULL,
    regionname character varying(255)
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_regionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.regions ALTER COLUMN regionid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.regions_regionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: segment_sales_profit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.segment_sales_profit AS
 SELECT seg.segmentname,
    avg(o.sales) AS avgsales,
    avg(o.profit) AS avgprofit
   FROM ((public.orders o
     JOIN public.customers cust ON (((o.customerid)::text = (cust.customerid)::text)))
     JOIN public.segments seg ON ((cust.segmentid = seg.segmentid)))
  GROUP BY seg.segmentname;


ALTER TABLE public.segment_sales_profit OWNER TO postgres;

--
-- Name: segments_segmentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.segments ALTER COLUMN segmentid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.segments_segmentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: shipments_shipmentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.shipments ALTER COLUMN shipmentid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.shipments_shipmentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: states_stateid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.states ALTER COLUMN stateid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.states_stateid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: subcategories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subcategories (
    subcategoryid integer NOT NULL,
    subcategoryname character varying(255)
);


ALTER TABLE public.subcategories OWNER TO postgres;

--
-- Name: subcategories_subcategoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.subcategories ALTER COLUMN subcategoryid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.subcategories_subcategoryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: super_store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.super_store (
    "Order ID" text,
    "Order Date" text,
    "Ship Date" text,
    "Ship Mode" text,
    "Customer ID" text,
    "Customer Name" text,
    "Segment" text,
    "Country" text,
    "City" text,
    "State" text,
    "Region" text,
    "Product ID" text,
    "Category" text,
    "Sub-Category" text,
    "Product Name" text,
    "Sales" numeric,
    "Quantity" integer,
    "Profit" numeric
);


ALTER TABLE public.super_store OWNER TO postgres;

--
-- Data for Name: denormalized_data_mart; Type: TABLE DATA; Schema: data_mart; Owner: postgres
--

COPY data_mart.denormalized_data_mart (countryname, statename, cityname, regionname, categoryname, subcategoryname, productname, customername, segmentname, orderdate, shipdate, shipmode, sales, quantity, profit) FROM stdin;
United States	Kentucky	Henderson	South	Furniture	Bookcases	Bush Somerset Collection Bookcase	Claire Gute	Consumer	2019-11-08	2019-11-11	Second Class	261.96	2	41.9136
United States	Kentucky	Henderson	South	Furniture	Chairs	Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back	Claire Gute	Consumer	2019-11-08	2019-11-11	Second Class	261.96	2	41.9136
United States	California	Los Angeles	West	Office Supplies	Labels	Self-Adhesive Address Labels for Typewriters by Universal	Darrin Van Huff	Corporate	2019-06-12	2019-06-16	Second Class	14.62	2	6.8714
United States	New Hampshire	Concord	East	Office Supplies	Paper	Xerox 1967	Andrew Allen	Consumer	2020-04-15	2020-04-20	Standard Class	15.55	3	5.4432
United States	Washington	Seattle	West	Office Supplies	Binders	Fellowes PB200 Plastic Comb Binding Machine	Irene Maddox	Consumer	2019-12-05	2019-12-10	Standard Class	407.98	3	132.5922
United States	Nebraska	Fremont	Central	Office Supplies	Art	Newell 318	Ken Black	Corporate	2019-12-09	2019-12-13	Standard Class	19.46	7	5.0596
United States	Nebraska	Fremont	Central	Office Supplies	Appliances	Acco Six-Outlet Power Strip, 4' Cord Length	Ken Black	Corporate	2019-12-09	2019-12-13	Standard Class	19.46	7	5.0596
United States	Pennsylvania	Philadelphia	East	Furniture	Chairs	Global Deluxe Stacking Chair, Gray	Sandra Flanagan	Consumer	2020-07-16	2020-07-18	Second Class	71.37	2	-1.0196
United States	California	Los Angeles	West	Office Supplies	Binders	Wilson Jones Active Use Binders	Eric Hoffmann	Consumer	2019-01-16	2019-01-20	Second Class	11.65	2	4.2224
United States	California	Los Angeles	West	Technology	Accessories	Imation�8GB Mini TravelDrive USB 2.0�Flash Drive	Eric Hoffmann	Consumer	2019-01-16	2019-01-20	Second Class	11.65	2	4.2224
United States	Texas	Houston	Central	Office Supplies	Paper	Easy-staple paper	Matt Abelman	Home Office	2020-10-19	2020-10-23	Second Class	29.47	3	9.9468
United States	Texas	Richardson	Central	Technology	Phones	GE 30524EE4	Gene Hale	Corporate	2019-12-08	2019-12-10	First Class	1097.54	7	123.4737
United States	Texas	Richardson	Central	Furniture	Furnishings	Electrix Architect's Clamp-On Swing Arm Lamp, Black	Gene Hale	Corporate	2019-12-08	2019-12-10	First Class	1097.54	7	123.4737
United States	Illinois	Naperville	Central	Technology	Phones	Panasonic Kx-TS550	Linda Cazamias	Corporate	2020-09-10	2020-09-15	Standard Class	147.17	4	16.5564
United States	California	Los Angeles	West	Office Supplies	Storage	Eldon Base for stackable storage shelf, platinum	Ruben Ausman	Corporate	2019-07-17	2019-07-22	Standard Class	77.88	2	3.8940
United States	Florida	Melbourne	South	Office Supplies	Storage	Advantus 10-Drawer Portable Organizer, Chrome Metal Frame, Smoke Drawers	Erin Smith	Corporate	2020-09-19	2020-09-23	Standard Class	95.62	2	9.5616
United States	Minnesota	Eagan	Central	Technology	Accessories	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 25/Pack	Odella Nelson	Corporate	2019-03-11	2019-03-13	First Class	45.98	2	19.7714
United States	Minnesota	Eagan	Central	Office Supplies	Binders	Wilson Jones Leather-Like Binders with DublLock Round Rings	Odella Nelson	Corporate	2019-03-11	2019-03-13	First Class	45.98	2	19.7714
United States	Delaware	Dover	East	Technology	Accessories	Imation�8gb Micro Traveldrive Usb 2.0�Flash Drive	Lena Hernandez	Consumer	2019-06-20	2019-06-25	Standard Class	45.00	3	4.9500
United States	Delaware	Dover	East	Technology	Phones	LF Elite 3D Dazzle Designer Hard Case Cover, Lf Stylus Pen and Wiper For Apple Iphone 5c Mini Lite	Lena Hernandez	Consumer	2019-06-20	2019-06-25	Standard Class	45.00	3	4.9500
United States	Michigan	Canton	Central	Office Supplies	Fasteners	Advantus Push Pins	Janet Molinari	Corporate	2019-12-11	2019-12-17	Standard Class	15.26	7	6.2566
United States	Michigan	Canton	Central	Technology	Phones	AT&T CL83451 4-Handset Telephone	Janet Molinari	Corporate	2019-12-11	2019-12-17	Standard Class	15.26	7	6.2566
United States	New York	Troy	East	Office Supplies	Storage	Home/Office Personal File Carts	Ted Butterfield	Consumer	2019-06-17	2019-06-18	First Class	208.56	6	52.1400
United States	New York	Troy	East	Office Supplies	Paper	Xerox 232	Ted Butterfield	Consumer	2019-06-17	2019-06-18	First Class	208.56	6	52.1400
United States	New York	Troy	East	Furniture	Chairs	Novimex Turbo Task Chair	Ted Butterfield	Consumer	2019-06-17	2019-06-18	First Class	208.56	6	52.1400
United States	New York	Troy	East	Office Supplies	Paper	Array Parchment Paper, Assorted Colors	Ted Butterfield	Consumer	2019-06-17	2019-06-18	First Class	208.56	6	52.1400
United States	New York	Troy	East	Technology	Accessories	Imation�8gb Micro Traveldrive Usb 2.0�Flash Drive	Ted Butterfield	Consumer	2019-06-17	2019-06-18	First Class	208.56	6	52.1400
United States	New York	Troy	East	Office Supplies	Binders	Plastic Binding Combs	Ted Butterfield	Consumer	2019-06-17	2019-06-18	First Class	208.56	6	52.1400
United States	New York	Troy	East	Office Supplies	Art	Prang Dustless Chalk Sticks	Ted Butterfield	Consumer	2019-06-17	2019-06-18	First Class	208.56	6	52.1400
United States	Virginia	Springfield	South	Office Supplies	Paper	Snap-A-Way Black Print Carbonless Ruled Speed Letter, Triplicate	Karen Daniels	Consumer	2019-06-04	2019-06-06	First Class	75.88	2	35.6636
United States	New York	New York City	East	Office Supplies	Binders	Avery Binding System Hidden Tab Executive Style Index Sets	Henry MacAllister	Consumer	2019-09-18	2019-09-23	Standard Class	4.62	1	1.7310
United States	Mississippi	Jackson	South	Office Supplies	Paper	Telephone Message Books with Fax/Mobile Section, 5 1/2" x 3 3/16"	Tracy Blumstein	Consumer	2020-09-14	2020-09-17	Second Class	19.05	3	8.7630
United States	Texas	Houston	Central	Office Supplies	Binders	Economy Binders	Ken Brennan	Corporate	2020-12-09	2020-12-11	First Class	1.25	3	-1.9344
United States	Texas	Houston	Central	Furniture	Furnishings	6" Cubicle Wall Clock, Black	Ken Brennan	Corporate	2020-12-09	2020-12-11	First Class	1.25	3	-1.9344
United States	Texas	Houston	Central	Office Supplies	Storage	SimpliFile Personal File, Black Granite, 15w x 6-15/16d x 11-1/4h	Ken Brennan	Corporate	2020-12-09	2020-12-11	First Class	1.25	3	-1.9344
United States	Alabama	Decatur	South	Office Supplies	Appliances	1.7 Cubic Foot Compact "Cube" Office Refrigerators	Stewart Carmichael	Corporate	2019-06-12	2019-06-15	First Class	208.16	1	56.2032
United States	Alabama	Decatur	South	Office Supplies	Binders	Avery Heavy-Duty EZD  Binder With Locking Rings	Stewart Carmichael	Corporate	2019-06-12	2019-06-15	First Class	208.16	1	56.2032
United States	Illinois	Chicago	Central	Office Supplies	Storage	Safco Industrial Wire Shelving	Christopher Schild	Home Office	2020-11-13	2020-11-16	First Class	230.38	3	-48.9549
United States	South Carolina	Columbia	South	Furniture	Chairs	Novimex Swivel Fabric Task Chair	Patrick O'Donnell	Consumer	2020-05-28	2020-05-30	Second Class	301.96	2	33.2156
United States	Minnesota	Rochester	Central	Technology	Accessories	Logitech�LS21 Speaker System - PC Multimedia - 2.1-CH - Wired	Paul Gonzalez	Consumer	2020-10-26	2020-11-02	Standard Class	19.99	1	6.7966
United States	Minnesota	Rochester	Central	Office Supplies	Labels	Avery 511	Paul Gonzalez	Consumer	2020-10-26	2020-11-02	Standard Class	19.99	1	6.7966
United States	Texas	Houston	Central	Office Supplies	Storage	Eldon Portable Mobile Manager	Gary Mitchum	Home Office	2019-04-05	2019-04-10	Second Class	158.37	7	13.8572
United States	California	Los Angeles	West	Office Supplies	Art	Turquoise Lead Holder with Pocket Clip	Jim Sink	Corporate	2019-09-17	2019-09-22	Standard Class	20.10	3	6.6330
United States	California	Los Angeles	West	Technology	Phones	Panasonic Kx-TS550	Jim Sink	Corporate	2019-09-17	2019-09-22	Standard Class	20.10	3	6.6330
United States	California	Los Angeles	West	Office Supplies	Paper	Xerox 1995	Jim Sink	Corporate	2019-09-17	2019-09-22	Standard Class	20.10	3	6.6330
United States	Oregon	Portland	West	Office Supplies	Binders	Flexible Leather- Look Classic Collection Ring Binder	Roger Barcio	Home Office	2020-11-06	2020-11-12	Standard Class	5.68	1	-3.7880
United States	New York	New York City	East	Furniture	Furnishings	9-3/4 Diameter Round Wall Clock	Parhena Norris	Home Office	2020-11-09	2020-11-11	Second Class	96.53	7	40.5426
United States	California	San Francisco	West	Office Supplies	Binders	Trimflex Flexible Post Binders	Katherine Ducich	Consumer	2020-06-17	2020-06-20	First Class	51.31	3	17.9592
United States	Minnesota	Saint Paul	Central	Office Supplies	Appliances	Fellowes Basic Home/Office Series Surge Protectors	Elpida Rittenbach	Corporate	2019-09-06	2019-09-11	Standard Class	77.88	6	22.5852
United States	California	Vallejo	West	Office Supplies	Paper	Avery Personal Creations Heavyweight Cards	Rick Bensley	Home Office	2019-08-29	2019-09-02	Standard Class	64.62	7	22.6184
United States	California	Vallejo	West	Technology	Accessories	SanDisk Ultra 64 GB MicroSDHC Class 10 Memory Card	Rick Bensley	Home Office	2019-08-29	2019-09-02	Standard Class	64.62	7	22.6184
United States	California	Vallejo	West	Office Supplies	Binders	Avery Hidden Tab Dividers for Binding Systems	Rick Bensley	Home Office	2019-08-29	2019-09-02	Standard Class	64.62	7	22.6184
United States	Minnesota	Rochester	Central	Office Supplies	Paper	Universal Premium White Copier/Laser Paper (20Lb. and 87 Bright)	Gary Zandusky	Consumer	2019-12-01	2019-12-04	Second Class	23.92	4	11.7208
United States	North Carolina	Charlotte	South	Technology	Accessories	Memorex Mini Travel Drive 8 GB USB 2.0 Flash Drive	Janet Martin	Consumer	2020-11-23	2020-11-28	Standard Class	74.11	8	17.6016
United States	North Carolina	Charlotte	South	Technology	Phones	Speck Products Candyshell Flip Case	Janet Martin	Consumer	2020-11-23	2020-11-28	Standard Class	74.11	8	17.6016
United States	North Carolina	Charlotte	South	Office Supplies	Art	Newell Chalk Holder	Janet Martin	Consumer	2020-11-23	2020-11-28	Standard Class	74.11	8	17.6016
United States	New York	New York City	East	Furniture	Furnishings	Magnifier Swing Arm Lamp	Cynthia Voltz	Corporate	2020-12-25	2020-12-30	Standard Class	41.96	2	10.9096
United States	California	Lancaster	West	Office Supplies	Art	Hunt PowerHouse Electric Pencil Sharpener, Blue	Clay Ludtke	Consumer	2019-11-03	2019-11-10	Standard Class	75.96	2	22.7880
United States	California	Lancaster	West	Office Supplies	Binders	Avery Durable Plastic 1" Binders	Clay Ludtke	Consumer	2019-11-03	2019-11-10	Standard Class	75.96	2	22.7880
United States	Delaware	Wilmington	East	Furniture	Furnishings	Artistic Insta-Plaque	Steven Cartwright	Consumer	2019-06-12	2019-06-15	First Class	47.04	3	18.3456
United States	Delaware	Wilmington	East	Office Supplies	Binders	DXL Angle-View Binders with Locking Rings by Samsill	Steven Cartwright	Consumer	2019-06-12	2019-06-15	First Class	47.04	3	18.3456
United States	Delaware	Wilmington	East	Office Supplies	Storage	Companion Letter/Legal File, Black	Steven Cartwright	Consumer	2019-06-12	2019-06-15	First Class	47.04	3	18.3456
United States	Delaware	Wilmington	East	Office Supplies	Envelopes	Globe Weis Peel & Seel First Class Envelopes	Steven Cartwright	Consumer	2019-06-12	2019-06-15	First Class	47.04	3	18.3456
United States	Delaware	Wilmington	East	Technology	Phones	KLD Oscar II Style Snap-on Ultra Thin Side Flip Synthetic Leather Cover Case for HTC One HTC M7	Steven Cartwright	Consumer	2019-06-12	2019-06-15	First Class	47.04	3	18.3456
United States	Arizona	Phoenix	West	Office Supplies	Binders	Avery Durable Slant Ring Binders, No Labels	Troy Staebel	Consumer	2020-11-05	2020-11-12	Standard Class	2.39	2	-1.8308
United States	Arizona	Phoenix	West	Office Supplies	Storage	Trav-L-File Heavy-Duty Shuttle II, Black	Troy Staebel	Consumer	2020-11-05	2020-11-12	Standard Class	2.39	2	-1.8308
United States	California	Los Angeles	West	Furniture	Chairs	Global Task Chair, Black	Lindsay Shagiari	Home Office	2019-11-06	2019-11-10	Second Class	81.42	2	-9.1602
United States	California	Los Angeles	West	Furniture	Furnishings	Eldon Cleatmat Plus Chair Mats for High Pile Carpets	Lindsay Shagiari	Home Office	2019-11-06	2019-11-10	Second Class	81.42	2	-9.1602
United States	Indiana	Columbus	Central	Technology	Phones	Anker 36W 4-Port USB Wall Charger Travel Power Adapter for iPhone 5s 5c 5	Dorothy Wardle	Corporate	2020-02-02	2020-02-05	First Class	59.97	5	-11.9940
United States	Indiana	Columbus	Central	Office Supplies	Paper	Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages	Dorothy Wardle	Corporate	2020-02-02	2020-02-05	First Class	59.97	5	-11.9940
United States	Indiana	Columbus	Central	Office Supplies	Fasteners	Staples	Dorothy Wardle	Corporate	2020-02-02	2020-02-05	First Class	59.97	5	-11.9940
United States	California	Roseville	West	Office Supplies	Paper	Xerox 195	Lena Creighton	Consumer	2019-10-13	2019-10-19	Standard Class	20.04	3	9.6192
United States	California	Roseville	West	Office Supplies	Paper	Xerox 1880	Lena Creighton	Consumer	2019-10-13	2019-10-19	Standard Class	20.04	3	9.6192
United States	California	Roseville	West	Office Supplies	Art	Sanford Colorific Colored Pencils, 12/Box	Lena Creighton	Consumer	2019-10-13	2019-10-19	Standard Class	20.04	3	9.6192
United States	California	Roseville	West	Office Supplies	Fasteners	Ideal Clamps	Lena Creighton	Consumer	2019-10-13	2019-10-19	Standard Class	20.04	3	9.6192
United States	California	Roseville	West	Office Supplies	Binders	GBC Wire Binding Strips	Lena Creighton	Consumer	2019-10-13	2019-10-19	Standard Class	20.04	3	9.6192
United States	California	Roseville	West	Office Supplies	Supplies	Fiskars Softgrip Scissors	Lena Creighton	Consumer	2019-10-13	2019-10-19	Standard Class	20.04	3	9.6192
United States	California	Roseville	West	Furniture	Furnishings	Longer-Life Soft White Bulbs	Lena Creighton	Consumer	2019-10-13	2019-10-19	Standard Class	20.04	3	9.6192
United States	Pennsylvania	Philadelphia	East	Furniture	Furnishings	Howard Miller 13-3/4" Diameter Brushed Chrome Round Wall Clock	Jonathan Doherty	Corporate	2019-09-05	2019-09-07	Second Class	82.80	2	10.3500
United States	California	San Francisco	West	Office Supplies	Art	Newell 343	Sally Hughsby	Corporate	2020-09-18	2020-09-23	Standard Class	8.82	3	2.3814
United States	California	San Francisco	West	Office Supplies	Envelopes	Convenience Packs of Business Envelopes	Sally Hughsby	Corporate	2020-09-18	2020-09-23	Standard Class	8.82	3	2.3814
United States	California	San Francisco	West	Office Supplies	Paper	Xerox 1911	Sally Hughsby	Corporate	2020-09-18	2020-09-23	Standard Class	8.82	3	2.3814
United States	Missouri	Independence	Central	Office Supplies	Appliances	Sanyo 2.5 Cubic Foot Mid-Size Office Refrigerators	Sandra Glassco	Consumer	2020-12-22	2020-12-27	Standard Class	839.43	3	218.2518
United States	Tennessee	Franklin	South	Technology	Phones	Plantronics Cordless�Phone Headset�with In-line Volume - M214C	Justin Ellison	Corporate	2019-12-05	2019-12-09	Standard Class	384.45	11	103.8015
United States	Tennessee	Franklin	South	Technology	Phones	Anker Astro 15000mAh USB Portable Charger	Justin Ellison	Corporate	2019-12-05	2019-12-09	Standard Class	384.45	11	103.8015
United States	Tennessee	Franklin	South	Furniture	Chairs	Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back	Justin Ellison	Corporate	2019-12-05	2019-12-09	Standard Class	384.45	11	103.8015
United States	Tennessee	Franklin	South	Office Supplies	Binders	GBC Prestige Therm-A-Bind Covers	Justin Ellison	Corporate	2019-12-05	2019-12-09	Standard Class	384.45	11	103.8015
United States	Arizona	Scottsdale	West	Office Supplies	Appliances	Belkin 7 Outlet SurgeMaster Surge Protector with Phone Protection	Tamara Willingham	Home Office	2019-03-13	2019-03-16	First Class	157.92	5	17.7660
United States	Arizona	Scottsdale	West	Technology	Phones	Jabra BIZ 2300 Duo QD Duo Corded�Headset	Tamara Willingham	Home Office	2019-03-13	2019-03-16	First Class	157.92	5	17.7660
United States	Oklahoma	Edmond	Central	Office Supplies	Labels	Avery 519	Nora Paige	Consumer	2019-11-20	2019-11-24	Standard Class	14.62	2	6.8714
United States	Oklahoma	Edmond	Central	Technology	Phones	Avaya 5420 Digital phone	Nora Paige	Consumer	2019-11-20	2019-11-24	Standard Class	14.62	2	6.8714
United States	California	Los Angeles	West	Office Supplies	Paper	Xerox 1920	Ted Trevino	Consumer	2019-05-11	2019-05-12	First Class	5.98	1	2.6910
United States	New Mexico	Carlsbad	West	Office Supplies	Envelopes	Staple envelope	Ruben Dartt	Consumer	2019-11-16	2019-11-20	Standard Class	28.40	5	13.3480
United States	Washington	Seattle	West	Office Supplies	Binders	Wilson Jones International Size A4 Ring Binders	Max Jones	Consumer	2019-11-07	2019-11-11	Standard Class	27.68	2	9.6880
United States	Texas	Houston	Central	Office Supplies	Appliances	Acco 7-Outlet Masterpiece Power Center, Wihtout Fax/Phone Line Protection	Shirley Jackson	Consumer	2020-04-21	2020-04-25	Second Class	97.26	4	-243.1600
United States	Connecticut	Fairfield	East	Office Supplies	Binders	Avery Poly Binder Pockets	Sally Knutson	Consumer	2019-11-28	2019-12-02	Standard Class	7.16	2	3.4368
United States	Texas	Grand Prairie	Central	Office Supplies	Storage	Personal Filing Tote with Lid, Black/Gray	Alice McCarthy	Corporate	2019-07-16	2019-07-22	Standard Class	37.22	3	3.7224
United States	Texas	Grand Prairie	Central	Office Supplies	Paper	Southworth 25% Cotton Antique Laid Paper & Envelopes	Alice McCarthy	Corporate	2019-07-16	2019-07-22	Standard Class	37.22	3	3.7224
United States	New Jersey	Westfield	East	Office Supplies	Storage	Decoflex Hanging Personal Folder File	Valerie Mitchum	Home Office	2020-11-06	2020-11-13	Standard Class	46.26	3	12.0276
United States	Pennsylvania	Philadelphia	East	Office Supplies	Binders	Pressboard Covers with Storage Hooks, 9 1/2" x 11", Light Blue	Fred Hopkins	Corporate	2020-07-06	2020-07-13	Standard Class	2.95	2	-2.2586
United States	Pennsylvania	Philadelphia	East	Office Supplies	Paper	Wirebound Message Books, 5-1/2 x 4 Forms, 2 or 4 Forms per Page	Fred Hopkins	Corporate	2020-07-06	2020-07-13	Standard Class	2.95	2	-2.2586
United States	Ohio	Akron	East	Office Supplies	Paper	Southworth 25% Cotton Linen-Finish Paper & Envelopes	Maria Bertelson	Consumer	2020-06-24	2020-06-29	Standard Class	21.74	3	6.7950
United States	California	San Francisco	West	Office Supplies	Appliances	Eureka Sanitaire  Commercial Upright	Logan Currie	Consumer	2020-12-17	2020-12-21	Second Class	66.28	2	-178.9668
United States	North Carolina	Charlotte	South	Furniture	Furnishings	Eldon 200 Class Desk Accessories, Burgundy	Heather Kirkland	Corporate	2020-06-03	2020-06-07	Standard Class	35.17	7	9.6712
United States	California	Whittier	West	Technology	Phones	Nortel Business Series Terminal T7208 Digital phone	Laurel Elliston	Consumer	2020-12-09	2020-12-14	Standard Class	444.77	4	44.4768
United States	Michigan	Saginaw	Central	Office Supplies	Storage	Tennsco Lockers, Gray	Joseph Holt	Consumer	2020-12-01	2020-12-07	Standard Class	83.92	4	5.8744
United States	Michigan	Saginaw	Central	Technology	Phones	Panasonic KX-TG6844B Expandable Digital Cordless Telephone	Joseph Holt	Consumer	2020-12-01	2020-12-07	Standard Class	83.92	4	5.8744
United States	Michigan	Saginaw	Central	Office Supplies	Binders	Avery Durable Slant Ring Binders, No Labels	Joseph Holt	Consumer	2020-12-01	2020-12-07	Standard Class	83.92	4	5.8744
United States	Michigan	Saginaw	Central	Office Supplies	Fasteners	Advantus Push Pins, Aluminum Head	Joseph Holt	Consumer	2020-12-01	2020-12-07	Standard Class	83.92	4	5.8744
United States	Michigan	Saginaw	Central	Office Supplies	Storage	Gould Plastics 18-Pocket Panel Bin, 34w x 5-1/4d x 20-1/2h	Joseph Holt	Consumer	2020-12-01	2020-12-07	Standard Class	83.92	4	5.8744
United States	California	Los Angeles	West	Office Supplies	Storage	Personal Filing Tote with Lid, Black/Gray	Jonathan Howell	Consumer	2019-10-28	2019-11-01	Standard Class	93.06	6	26.0568
United States	California	Los Angeles	West	Technology	Phones	Adtran 1202752G1	Jonathan Howell	Consumer	2019-10-28	2019-11-01	Standard Class	93.06	6	26.0568
United States	Illinois	Chicago	Central	Furniture	Tables	Bush Advantage Collection Round Conference Table	Christopher Schild	Home Office	2020-04-07	2020-04-12	Standard Class	233.86	2	-102.0480
United States	Illinois	Chicago	Central	Furniture	Tables	Bretford Rectangular Conference Table Tops	Christopher Schild	Home Office	2020-04-07	2020-04-12	Standard Class	233.86	2	-102.0480
United States	Illinois	Chicago	Central	Office Supplies	Binders	GBC Instant Index System for Binding Systems	Christopher Schild	Home Office	2020-04-07	2020-04-12	Standard Class	233.86	2	-102.0480
United States	Illinois	Chicago	Central	Furniture	Furnishings	Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39" x 49"	Christopher Schild	Home Office	2020-04-07	2020-04-12	Standard Class	233.86	2	-102.0480
United States	Illinois	Chicago	Central	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	Christopher Schild	Home Office	2020-04-07	2020-04-12	Standard Class	233.86	2	-102.0480
United States	California	Santa Clara	West	Office Supplies	Paper	Xerox 4200 Series MultiUse Premium Copy Paper (20Lb. and 84 Bright)	David Bremer	Corporate	2020-11-12	2020-11-16	Standard Class	10.56	2	4.7520
United States	Illinois	Chicago	Central	Office Supplies	Paper	Xerox 1957	Ken Lonsdale	Consumer	2019-06-04	2019-06-09	Second Class	25.92	5	9.3960
United States	Illinois	Chicago	Central	Furniture	Furnishings	Luxo Professional Fluorescent Magnifier Lamp with Clamp-Mount Base	Ken Lonsdale	Consumer	2019-06-04	2019-06-09	Second Class	25.92	5	9.3960
United States	Illinois	Chicago	Central	Furniture	Furnishings	Staple-based wall hangings	Ken Lonsdale	Consumer	2019-06-04	2019-06-09	Second Class	25.92	5	9.3960
United States	Illinois	Chicago	Central	Technology	Phones	PureGear Roll-On Screen Protector	Ken Lonsdale	Consumer	2019-06-04	2019-06-09	Second Class	25.92	5	9.3960
United States	Illinois	Chicago	Central	Furniture	Tables	KI Conference Tables	Ken Lonsdale	Consumer	2019-06-04	2019-06-09	Second Class	25.92	5	9.3960
United States	Illinois	Chicago	Central	Furniture	Furnishings	Eldon 100 Class Desk Accessories	Ken Lonsdale	Consumer	2019-06-04	2019-06-09	Second Class	25.92	5	9.3960
United States	Illinois	Chicago	Central	Office Supplies	Art	Binney & Smith Crayola Metallic Colored Pencils, 8-Color Set	Ken Lonsdale	Consumer	2019-06-04	2019-06-09	Second Class	25.92	5	9.3960
United States	California	Los Angeles	West	Furniture	Chairs	Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black	Logan Haushalter	Consumer	2019-12-10	2019-12-15	Second Class	321.57	2	28.1372
United States	Ohio	Newark	East	Office Supplies	Paper	Wirebound Message Books, Two 4 1/4" x 5" Forms per Page	Kelly Collister	Consumer	2019-09-11	2019-09-17	Standard Class	7.61	1	3.5767
United States	Ohio	Newark	East	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	Kelly Collister	Consumer	2019-09-11	2019-09-17	Standard Class	7.61	1	3.5767
United States	New York	New York City	East	Office Supplies	Storage	Fellowes Personal Hanging Folder Files, Navy	Delfina Latchford	Consumer	2019-12-10	2019-12-13	First Class	80.58	6	22.5624
United States	New York	New York City	East	Office Supplies	Envelopes	Tyvek Side-Opening Peel & Seel Expanding Envelopes	Delfina Latchford	Consumer	2019-12-10	2019-12-13	First Class	80.58	6	22.5624
United States	Illinois	Chicago	Central	Technology	Accessories	Sabrent 4-Port USB 2.0 Hub	Craig Carreira	Consumer	2020-12-01	2020-12-03	Second Class	20.37	3	6.9258
United States	Illinois	Chicago	Central	Office Supplies	Storage	Safco Industrial Shelving	Craig Carreira	Consumer	2020-12-01	2020-12-03	Second Class	20.37	3	6.9258
United States	Illinois	Chicago	Central	Office Supplies	Binders	Acco 3-Hole Punch	Craig Carreira	Consumer	2020-12-01	2020-12-03	Second Class	20.37	3	6.9258
United States	Ohio	Cleveland	East	Office Supplies	Appliances	Eureka Disposable Bags for Sanitaire Vibra Groomer I Upright Vac	Dorris liebe	Corporate	2020-06-08	2020-06-12	Standard Class	1.62	2	-4.4660
United States	Kentucky	Louisville	South	Technology	Phones	Cisco Small Business SPA 502G VoIP phone	Roy Collins	Consumer	2019-06-06	2019-06-13	Standard Class	328.22	4	28.7196
United States	North Carolina	Chapel Hill	South	Office Supplies	Art	Quartet Omega Colored Chalk, 12/Pack	Claudia Bergmann	Corporate	2020-06-16	2020-06-20	Standard Class	14.02	3	4.7304
United States	Minnesota	Rochester	Central	Office Supplies	Fasteners	Bagged Rubber Bands	Paul Gonzalez	Consumer	2019-01-22	2019-01-28	Standard Class	7.56	6	0.3024
United States	Ohio	Cincinnati	East	Office Supplies	Storage	Safco Commercial Shelving	Christine Abelman	Corporate	2020-12-09	2020-12-13	Standard Class	37.21	1	-7.4416
United States	Ohio	Cincinnati	East	Office Supplies	Envelopes	Recycled Interoffice Envelopes with String and Button Closure, 10 x 13	Christine Abelman	Corporate	2020-12-09	2020-12-13	Standard Class	37.21	1	-7.4416
United States	California	Los Angeles	West	Office Supplies	Storage	Adjustable Depth Letter/Legal Cart	Kristen Hastings	Corporate	2020-12-28	2019-01-02	Second Class	725.84	4	210.4936
United States	California	Inglewood	West	Office Supplies	Paper	Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled	Barry Blumstein	Corporate	2020-09-16	2020-09-17	First Class	8.82	2	4.0572
United States	California	Inglewood	West	Office Supplies	Art	Newell 330	Barry Blumstein	Corporate	2020-09-16	2020-09-17	First Class	8.82	2	4.0572
United States	Pennsylvania	Philadelphia	East	Office Supplies	Paper	Post-it ?Important Message? Note Pad, Neon Colors, 50 Sheets/Pad	Andrew Gjertsen	Corporate	2020-10-13	2020-10-17	Standard Class	11.65	2	4.0768
United States	Pennsylvania	Philadelphia	East	Office Supplies	Paper	Adams Write n' Stick Phone Message Book, 11" X 5 1/4", 200 Messages	Andrew Gjertsen	Corporate	2020-10-13	2020-10-17	Standard Class	11.65	2	4.0768
United States	Pennsylvania	Philadelphia	East	Office Supplies	Storage	Eldon Simplefile Box Office	Andrew Gjertsen	Corporate	2020-10-13	2020-10-17	Standard Class	11.65	2	4.0768
United States	Pennsylvania	Philadelphia	East	Office Supplies	Labels	Avery 489	Andrew Gjertsen	Corporate	2020-10-13	2020-10-17	Standard Class	11.65	2	4.0768
United States	Florida	Tamarac	South	Office Supplies	Binders	GBC VeloBinder Electric Binding Machine	Alan Haines	Corporate	2019-12-18	2019-12-20	Second Class	254.06	7	-169.3720
United States	Florida	Tamarac	South	Office Supplies	Appliances	Acco 7-Outlet Masterpiece Power Center, Wihtout Fax/Phone Line Protection	Alan Haines	Corporate	2019-12-18	2019-12-20	Second Class	254.06	7	-169.3720
United States	Florida	Tamarac	South	Office Supplies	Supplies	Premier Automatic Letter Opener	Alan Haines	Corporate	2019-12-18	2019-12-20	Second Class	254.06	7	-169.3720
United States	Indiana	Columbus	Central	Office Supplies	Fasteners	Advantus SlideClip Paper Clips	Nick Zandusky	Home Office	2019-11-20	2019-11-24	Second Class	19.10	7	6.6836
United States	Indiana	Columbus	Central	Office Supplies	Labels	Avery 512	Nick Zandusky	Home Office	2019-11-20	2019-11-24	Second Class	19.10	7	6.6836
United States	Indiana	Columbus	Central	Technology	Accessories	Logitech Wireless Gaming Headset G930	Nick Zandusky	Home Office	2019-11-20	2019-11-24	Second Class	19.10	7	6.6836
United States	Indiana	Columbus	Central	Furniture	Bookcases	Bush Westfield Collection Bookcases, Medium Cherry Finish	Nick Zandusky	Home Office	2019-11-20	2019-11-24	Second Class	19.10	7	6.6836
United States	Pennsylvania	Philadelphia	East	Office Supplies	Paper	Xerox 223	Jonathan Doherty	Corporate	2019-10-28	2019-11-03	Standard Class	32.40	5	15.5520
United States	Pennsylvania	Philadelphia	East	Office Supplies	Storage	Tennsco Stur-D-Stor Boltless Shelving, 5 Shelves, 24" Deep, Sand	Jonathan Doherty	Corporate	2019-10-28	2019-11-03	Standard Class	32.40	5	15.5520
United States	Pennsylvania	Philadelphia	East	Office Supplies	Paper	Xerox 1939	Jonathan Doherty	Corporate	2019-10-28	2019-11-03	Standard Class	32.40	5	15.5520
United States	Pennsylvania	Philadelphia	East	Furniture	Furnishings	Floodlight Indoor Halogen Bulbs, 1 Bulb per Pack, 60 Watts	Jonathan Doherty	Corporate	2019-10-28	2019-11-03	Standard Class	32.40	5	15.5520
United States	Pennsylvania	Philadelphia	East	Office Supplies	Binders	Avery Premier Heavy-Duty Binder with Round Locking Rings	Jonathan Doherty	Corporate	2019-10-28	2019-11-03	Standard Class	32.40	5	15.5520
United States	California	Los Angeles	West	Furniture	Tables	BPI Conference Tables	Jonathan Howell	Consumer	2020-11-19	2020-11-23	Standard Class	219.08	3	-131.4450
United States	Virginia	Arlington	South	Office Supplies	Art	Faber Castell Col-Erase Pencils	Shahid Hopkins	Consumer	2020-04-15	2020-04-17	First Class	4.89	1	2.0049
United States	Colorado	Arvada	West	Furniture	Furnishings	C-Line Cubicle Keepers Polyproplyene Holder With Velcro Backings	Ben Peterman	Corporate	2019-09-12	2019-09-14	Second Class	15.14	4	3.5948
United States	Colorado	Arvada	West	Furniture	Chairs	Hon 4070 Series Pagoda Armless Upholstered Stacking Chairs	Ben Peterman	Corporate	2019-09-12	2019-09-14	Second Class	15.14	4	3.5948
United States	Colorado	Arvada	West	Furniture	Furnishings	Eldon Expressions Desk Accessory, Wood Photo Frame, Mahogany	Ben Peterman	Corporate	2019-09-12	2019-09-14	Second Class	15.14	4	3.5948
United States	Colorado	Arvada	West	Office Supplies	Labels	Avery 509	Ben Peterman	Corporate	2019-09-12	2019-09-14	Second Class	15.14	4	3.5948
United States	California	Hesperia	West	Office Supplies	Binders	Ibico Laser Imprintable Binding System Covers	Grace Kelly	Corporate	2019-04-23	2019-04-27	Standard Class	251.52	6	81.7440
United States	California	Hesperia	West	Technology	Accessories	Logitech Wireless Headset h800	Grace Kelly	Corporate	2019-04-23	2019-04-27	Standard Class	251.52	6	81.7440
United States	Tennessee	Murfreesboro	South	Furniture	Furnishings	Telescoping Adjustable Floor Lamp	Don Jones	Corporate	2020-11-03	2020-11-05	Second Class	15.99	1	0.9995
United States	Pennsylvania	Philadelphia	East	Technology	Phones	Aastra 57i VoIP phone	Patrick O'Brill	Consumer	2019-08-30	2019-09-01	First Class	290.90	3	-67.8762
United States	Pennsylvania	Philadelphia	East	Office Supplies	Storage	File Shuttle II and Handi-File, Black	Patrick O'Brill	Consumer	2019-08-30	2019-09-01	First Class	290.90	3	-67.8762
United States	Pennsylvania	Philadelphia	East	Furniture	Chairs	Hon 2090 ?Pillow Soft? Series Mid Back Swivel/Tilt Chairs	Patrick O'Brill	Consumer	2019-08-30	2019-09-01	First Class	290.90	3	-67.8762
United States	Pennsylvania	Philadelphia	East	Office Supplies	Labels	Round Specialty Laser Printer Labels	Patrick O'Brill	Consumer	2019-08-30	2019-09-01	First Class	290.90	3	-67.8762
United States	Pennsylvania	Philadelphia	East	Office Supplies	Binders	GBC Premium Transparent Covers with Diagonal Lined Pattern	Patrick O'Brill	Consumer	2019-08-30	2019-09-01	First Class	290.90	3	-67.8762
United States	Pennsylvania	Philadelphia	East	Technology	Phones	AT&T 841000 Phone	John Lucas	Consumer	2019-04-25	2019-04-29	Second Class	82.80	2	-20.7000
United States	Pennsylvania	Philadelphia	East	Office Supplies	Binders	Ibico Recycled Grain-Textured Covers	John Lucas	Consumer	2019-04-25	2019-04-29	Second Class	82.80	2	-20.7000
United States	Pennsylvania	Philadelphia	East	Office Supplies	Binders	Wilson Jones Custom Binder Spines & Labels	John Lucas	Consumer	2019-04-25	2019-04-29	Second Class	82.80	2	-20.7000
United States	California	San Francisco	West	Technology	Phones	Anker 36W 4-Port USB Wall Charger Travel Power Adapter for iPhone 5s 5c 5	Clay Cheatham	Consumer	2020-06-15	2020-06-19	Standard Class	47.98	3	4.7976
United States	Massachusetts	Lowell	East	Office Supplies	Art	Binney & Smith inkTank Erasable Desk Highlighter, Chisel Tip, Yellow, 12/Box	Tamara Dahlen	Consumer	2020-07-08	2020-07-12	Standard Class	7.56	3	3.0996
United States	Massachusetts	Lowell	East	Office Supplies	Paper	Easy-staple paper	Tamara Dahlen	Consumer	2020-07-08	2020-07-12	Standard Class	7.56	3	3.0996
United States	Massachusetts	Lowell	East	Office Supplies	Art	BIC Brite Liner Highlighters, Chisel Tip	Tamara Dahlen	Consumer	2020-07-08	2020-07-12	Standard Class	7.56	3	3.0996
United States	New York	New York City	East	Technology	Accessories	Sabrent 4-Port USB 2.0 Hub	Adam Bellavance	Home Office	2019-09-01	2019-09-03	First Class	6.79	1	2.3086
United States	New York	New York City	East	Office Supplies	Paper	Xerox 1881	Adam Bellavance	Home Office	2019-09-01	2019-09-03	First Class	6.79	1	2.3086
United States	New York	New York City	East	Office Supplies	Binders	Acco Hanging Data Binders	Adam Bellavance	Home Office	2019-09-01	2019-09-03	First Class	6.79	1	2.3086
United States	New York	New York City	East	Office Supplies	Paper	Xerox 1881	Adam Bellavance	Home Office	2019-09-01	2019-09-03	First Class	6.79	1	2.3086
United States	New York	New York City	East	Office Supplies	Binders	GBC DocuBind P400 Electric Binding System	Adam Bellavance	Home Office	2019-09-01	2019-09-03	First Class	6.79	1	2.3086
United States	New York	New York City	East	Furniture	Bookcases	Sauder Barrister Bookcases	Jeremy Lonsdale	Consumer	2019-04-08	2019-04-13	Standard Class	388.70	6	-4.8588
United States	New York	New York City	East	Office Supplies	Envelopes	#10 Gummed Flap White Envelopes, 100/Box	Jeremy Lonsdale	Consumer	2019-04-08	2019-04-13	Standard Class	388.70	6	-4.8588
United States	New York	New York City	East	Office Supplies	Art	Dixon Prang Watercolor Pencils, 10-Color Set with Brush	Jeremy Lonsdale	Consumer	2019-04-08	2019-04-13	Standard Class	388.70	6	-4.8588
United States	New York	New York City	East	Office Supplies	Paper	Adams Phone Message Book, 200 Message Capacity, 8 1/16? x 11?	Jeremy Lonsdale	Consumer	2019-04-08	2019-04-13	Standard Class	388.70	6	-4.8588
United States	North Carolina	Charlotte	South	Office Supplies	Paper	Southworth 25% Cotton Linen-Finish Paper & Envelopes	Heather Kirkland	Corporate	2019-04-23	2019-04-28	Standard Class	36.24	5	11.3250
United States	Kentucky	Richmond	South	Office Supplies	Appliances	Belkin 8 Outlet SurgeMaster II Gold Surge Protector with Phone Protection	Victoria Brennan	Corporate	2020-03-08	2020-03-11	First Class	647.84	8	168.4384
United States	Kentucky	Richmond	South	Office Supplies	Labels	Avery Address/Shipping Labels for Typewriters, 4" x 2"	Victoria Brennan	Corporate	2020-03-08	2020-03-11	First Class	647.84	8	168.4384
United States	New York	New York City	East	Office Supplies	Labels	Avery Address/Shipping Labels for Typewriters, 4" x 2"	Katrina Willman	Consumer	2020-09-25	2020-10-01	Standard Class	20.70	2	9.9360
United States	New York	New York City	East	Furniture	Chairs	Global Ergonomic Managers Chair	Katrina Willman	Consumer	2020-09-25	2020-10-01	Standard Class	20.70	2	9.9360
United States	New York	New York City	East	Office Supplies	Art	Newell 333	Katrina Willman	Consumer	2020-09-25	2020-10-01	Standard Class	20.70	2	9.9360
United States	New York	New York City	East	Furniture	Furnishings	Eldon Wave Desk Accessories	Katrina Willman	Consumer	2020-09-25	2020-10-01	Standard Class	20.70	2	9.9360
United States	Connecticut	Manchester	East	Office Supplies	Binders	Wilson Jones ?Snap? Scratch Pad Binder Tool for Ring Binders	Michael Kennedy	Corporate	2019-10-21	2019-10-21	Same Day	23.20	4	10.4400
United States	Connecticut	Manchester	East	Office Supplies	Supplies	Staple remover	Michael Kennedy	Corporate	2019-10-21	2019-10-21	Same Day	23.20	4	10.4400
United States	Connecticut	Manchester	East	Office Supplies	Storage	Pizazz Global Quick File	Michael Kennedy	Corporate	2019-10-21	2019-10-21	Same Day	23.20	4	10.4400
United States	Connecticut	Manchester	East	Furniture	Bookcases	Atlantic Metals Mobile 3-Shelf Bookcases, Custom Colors	Michael Kennedy	Corporate	2019-10-21	2019-10-21	Same Day	23.20	4	10.4400
United States	Texas	Harlingen	Central	Office Supplies	Paper	Xerox 1930	Guy Thornton	Consumer	2020-05-29	2020-06-04	Standard Class	25.92	5	9.3960
United States	Texas	Harlingen	Central	Office Supplies	Storage	File Shuttle I and Handi-File	Guy Thornton	Consumer	2020-05-29	2020-06-04	Standard Class	25.92	5	9.3960
United States	Illinois	Quincy	Central	Office Supplies	Paper	Xerox 1960	Muhammed MacIntyre	Corporate	2019-09-28	2019-10-01	First Class	99.14	4	30.9800
United States	Tennessee	Franklin	South	Furniture	Tables	Office Impressions End Table, 20-1/2"H x 24"W x 20"D	Allen Rosenblatt	Corporate	2020-08-27	2020-09-01	Standard Class	1488.42	7	-297.6848
United States	Washington	Seattle	West	Office Supplies	Paper	Southworth Structures Collection	Alejandro Savely	Corporate	2019-10-28	2019-10-29	First Class	50.96	7	25.4800
United States	Washington	Seattle	West	Office Supplies	Binders	Square Ring Data Binders, Rigid 75 Pt. Covers, 11" x 14-7/8"	Alejandro Savely	Corporate	2019-10-28	2019-10-29	First Class	50.96	7	25.4800
United States	New York	New York City	East	Office Supplies	Binders	Angle-D Binders with Locking Rings, Label Holders	Mike Vittorini	Consumer	2020-12-11	2020-12-15	Standard Class	23.36	4	7.8840
United States	New York	New York City	East	Technology	Accessories	Logitech�LS21 Speaker System - PC Multimedia - 2.1-CH - Wired	Mike Vittorini	Consumer	2020-12-11	2020-12-15	Standard Class	23.36	4	7.8840
United States	Nevada	Las Vegas	West	Office Supplies	Binders	Tuf-Vin Binders	Victor Preis	Home Office	2020-06-30	2020-07-05	Standard Class	75.79	3	25.5798
United States	Rhode Island	Warwick	East	Office Supplies	Storage	2300 Heavy-Duty Transfer File Systems by Perma	Saphhira Shifley	Corporate	2020-10-17	2020-10-19	Second Class	49.96	2	9.4924
United States	Rhode Island	Warwick	East	Office Supplies	Paper	Xerox 1958	Saphhira Shifley	Corporate	2020-10-17	2020-10-19	Second Class	49.96	2	9.4924
United States	Texas	Houston	Central	Office Supplies	Storage	Super Decoflex Portable Personal File	Anna Gayman	Consumer	2019-09-08	2019-09-10	Second Class	35.95	3	3.5952
United States	Texas	Houston	Central	Furniture	Bookcases	Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish	Anna Gayman	Consumer	2019-09-08	2019-09-10	Second Class	35.95	3	3.5952
United States	Texas	Houston	Central	Office Supplies	Storage	Contico 72"H Heavy-Duty Storage System	Anna Gayman	Consumer	2019-09-08	2019-09-10	Second Class	35.95	3	3.5952
United States	Texas	Houston	Central	Technology	Accessories	Sony 64GB Class 10 Micro SDHC R40 Memory Card	Anna Gayman	Consumer	2019-09-08	2019-09-10	Second Class	35.95	3	3.5952
United States	New York	New York City	East	Office Supplies	Appliances	Staple holder	Roy Franz�sisch	Consumer	2020-12-24	2020-12-29	Standard Class	35.91	3	9.6957
United States	California	San Francisco	West	Technology	Accessories	Sony 64GB Class 10 Micro SDHC R40 Memory Card	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Technology	Copiers	Sharp AL-1530CS Digital Copier	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Office Supplies	Paper	Wirebound Message Book, 4 per Page	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Furniture	Tables	Bevis Round Conference Table Top, X-Base	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Office Supplies	Paper	Wirebound Service Call Books, 5 1/2" x 4"	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Office Supplies	Labels	Self-Adhesive Removable Labels	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Office Supplies	Paper	Xerox 1881	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Furniture	Bookcases	O'Sullivan 4-Shelf Bookcase in Odessa Pine	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	California	San Francisco	West	Furniture	Chairs	Novimex High-Tech Fabric Mesh Task Chair	Keith Herrera	Consumer	2020-12-08	2020-12-12	Standard Class	179.95	5	37.7895
United States	Washington	Seattle	West	Office Supplies	Paper	Xerox 191	Kimberly Carter	Corporate	2020-11-03	2020-11-07	Standard Class	139.86	7	65.7342
United States	Washington	Seattle	West	Furniture	Chairs	Global Deluxe Office Fabric Chairs	Kimberly Carter	Corporate	2020-11-03	2020-11-07	Standard Class	139.86	7	65.7342
United States	California	Huntington Beach	West	Office Supplies	Art	Bulldog Vacuum Base Pencil Sharpener	Caroline Jumper	Consumer	2020-06-24	2020-06-28	Standard Class	95.92	8	25.8984
United States	California	Los Angeles	West	Furniture	Chairs	Bevis Steel Folding Chairs	Philip Brown	Consumer	2019-04-14	2019-04-18	Standard Class	383.80	5	38.3800
United States	Kentucky	Richmond	South	Office Supplies	Paper	Xerox 1987	Victoria Brennan	Corporate	2020-11-06	2020-11-10	Standard Class	5.78	1	2.8322
United States	California	Los Angeles	West	Office Supplies	Art	American Pencil	Sung Pak	Corporate	2020-03-04	2020-03-09	Standard Class	9.32	4	2.7028
United States	California	Los Angeles	West	Office Supplies	Envelopes	White Envelopes, White Envelopes with Clear Poly Window	Sung Pak	Corporate	2020-03-04	2020-03-09	Standard Class	9.32	4	2.7028
United States	Massachusetts	Lawrence	East	Furniture	Furnishings	Westinghouse Mesh Shade Clip-On Gooseneck Lamp, Black	Michael Paige	Corporate	2020-10-19	2020-10-23	Standard Class	56.56	4	14.7056
United States	Massachusetts	Lawrence	East	Office Supplies	Storage	Crate-A-Files	Michael Paige	Corporate	2020-10-19	2020-10-23	Standard Class	56.56	4	14.7056
United States	Alabama	Decatur	South	Furniture	Chairs	Hon Multipurpose Stacking Arm Chairs	Natalie Fritzler	Consumer	2020-08-21	2020-08-23	Second Class	866.40	4	225.2640
United States	Michigan	Canton	Central	Furniture	Furnishings	Coloredge Poster Frame	Janet Molinari	Corporate	2020-11-23	2020-11-26	Second Class	28.40	2	11.0760
United States	Michigan	Canton	Central	Office Supplies	Binders	GBC VeloBinder Manual Binding System	Janet Molinari	Corporate	2020-11-23	2020-11-26	Second Class	28.40	2	11.0760
United States	Oklahoma	Norman	Central	Office Supplies	Art	Design Ebony Sketching Pencil	Ken Heidel	Corporate	2020-10-01	2020-10-08	Standard Class	6.67	6	0.5004
United States	North Carolina	Gastonia	South	Office Supplies	Binders	GBC ProClick 150 Presentation Binding System	Ross Baird	Home Office	2019-04-15	2019-04-21	Standard Class	189.59	2	-145.3508
United States	North Carolina	Gastonia	South	Technology	Accessories	Imation�Secure+ Hardware Encrypted USB 2.0�Flash Drive; 16GB	Ross Baird	Home Office	2019-04-15	2019-04-21	Standard Class	189.59	2	-145.3508
United States	North Carolina	Gastonia	South	Technology	Accessories	Imation�Secure+ Hardware Encrypted USB 2.0�Flash Drive; 16GB	Ross Baird	Home Office	2019-04-15	2019-04-21	Standard Class	189.59	2	-145.3508
United States	North Carolina	Gastonia	South	Office Supplies	Storage	Woodgrain Magazine Files by Perma	Ross Baird	Home Office	2019-04-15	2019-04-21	Standard Class	189.59	2	-145.3508
United States	Massachusetts	Lowell	East	Office Supplies	Storage	Letter Size Cart	Dave Brooks	Consumer	2019-06-06	2019-06-07	First Class	714.30	5	207.1470
United States	Illinois	Chicago	Central	Technology	Machines	Canon Color ImageCLASS MF8580Cdw Wireless Laser All-In-One Printer, Copier, Scanner	Philisse Overcash	Home Office	2019-06-12	2019-06-14	Second Class	1007.98	3	43.1991
United States	Illinois	Chicago	Central	Office Supplies	Paper	Xerox 1881	Philisse Overcash	Home Office	2019-06-12	2019-06-14	Second Class	1007.98	3	43.1991
United States	Texas	Houston	Central	Office Supplies	Paper	Xerox 1897	Brenda Bowman	Corporate	2020-09-15	2020-09-19	Standard Class	31.87	8	11.5536
United States	New York	New York City	East	Furniture	Chairs	Global Deluxe Steno Chair	Cynthia Voltz	Corporate	2020-01-20	2020-01-23	Second Class	207.85	3	2.3094
United States	Michigan	Detroit	Central	Furniture	Furnishings	Aluminum Document Frame	Pete Kriz	Consumer	2019-09-05	2019-09-07	Second Class	12.22	1	3.6660
United States	Michigan	Detroit	Central	Office Supplies	Storage	Fellowes Bankers Box Staxonsteel Drawer File/Stacking System	Pete Kriz	Consumer	2019-09-05	2019-09-07	Second Class	12.22	1	3.6660
United States	Michigan	Detroit	Central	Office Supplies	Storage	Eldon Mobile Mega Data Cart  Mega Stackable  Add-On Trays	Pete Kriz	Consumer	2019-09-05	2019-09-07	Second Class	12.22	1	3.6660
United States	Michigan	Detroit	Central	Office Supplies	Paper	Xerox Color Copier Paper, 11" x 17", Ream	Pete Kriz	Consumer	2019-09-05	2019-09-07	Second Class	12.22	1	3.6660
United States	Michigan	Detroit	Central	Furniture	Chairs	Office Star - Ergonomically Designed Knee Chair	Pete Kriz	Consumer	2019-09-05	2019-09-07	Second Class	12.22	1	3.6660
United States	Michigan	Detroit	Central	Office Supplies	Labels	Avery 520	Pete Kriz	Consumer	2019-09-05	2019-09-07	Second Class	12.22	1	3.6660
United States	Indiana	Columbus	Central	Furniture	Furnishings	GE General Purpose, Extra Long Life, Showcase & Floodlight Incandescent Bulbs	Troy Blackwell	Consumer	2020-03-20	2020-03-25	Second Class	2.91	1	1.3677
United States	New York	Auburn	East	Office Supplies	Art	Newell 345	Raymond Buch	Consumer	2019-04-01	2019-04-03	Second Class	59.52	3	15.4752
United States	New York	Auburn	East	Office Supplies	Storage	Fellowes Bankers Box Recycled Super Stor/Drawer	Raymond Buch	Consumer	2019-04-01	2019-04-03	Second Class	59.52	3	15.4752
United States	New York	Auburn	East	Office Supplies	Art	Boston 1645 Deluxe Heavier-Duty Electric Pencil Sharpener	Raymond Buch	Consumer	2019-04-01	2019-04-03	Second Class	59.52	3	15.4752
United States	New York	Auburn	East	Office Supplies	Art	50 Colored Long Pencils	Raymond Buch	Consumer	2019-04-01	2019-04-03	Second Class	59.52	3	15.4752
United States	New York	Auburn	East	Office Supplies	Art	Newell 342	Raymond Buch	Consumer	2019-04-01	2019-04-03	Second Class	59.52	3	15.4752
United States	New York	Auburn	East	Technology	Phones	Belkin Grip Candy Sheer Case / Cover for iPhone 5 and 5S	Raymond Buch	Consumer	2019-04-01	2019-04-03	Second Class	59.52	3	15.4752
United States	Ohio	Akron	East	Furniture	Tables	Chromcraft Rectangular Conference Tables	Ed Braxton	Corporate	2020-10-20	2020-10-24	Standard Class	284.36	2	-75.8304
United States	Ohio	Akron	East	Office Supplies	Storage	Deluxe Rollaway Locking File with Drawer	Ed Braxton	Corporate	2020-10-20	2020-10-24	Standard Class	284.36	2	-75.8304
United States	Oklahoma	Norman	Central	Technology	Accessories	Memorex Mini Travel Drive 16 GB USB 2.0 Flash Drive	Ken Heidel	Corporate	2019-12-13	2019-12-17	Standard Class	63.88	4	24.9132
United States	Alabama	Decatur	South	Furniture	Chairs	Hon 4700 Series Mobuis Mid-Back Task Chairs with Adjustable Arms	Natalie Fritzler	Consumer	2019-09-26	2019-10-01	Standard Class	747.56	3	-96.1146
United States	Alabama	Decatur	South	Office Supplies	Envelopes	Staple envelope	Natalie Fritzler	Consumer	2019-09-26	2019-10-01	Standard Class	747.56	3	-96.1146
United States	Arizona	Phoenix	West	Furniture	Furnishings	Eldon Wave Desk Accessories	Tanja Norvell	Home Office	2019-04-22	2019-04-29	Standard Class	23.56	5	7.0680
United States	Arizona	Phoenix	West	Furniture	Tables	Bush Advantage Collection Racetrack Conference Table	Tanja Norvell	Home Office	2019-04-22	2019-04-29	Standard Class	23.56	5	7.0680
United States	Arizona	Phoenix	West	Office Supplies	Binders	Poly Designer Cover & Back	Tanja Norvell	Home Office	2019-04-22	2019-04-29	Standard Class	23.56	5	7.0680
United States	Arizona	Phoenix	West	Office Supplies	Supplies	Premier Electric Letter Opener	Tanja Norvell	Home Office	2019-04-22	2019-04-29	Standard Class	23.56	5	7.0680
United States	Arizona	Phoenix	West	Office Supplies	Appliances	Fellowes Premier Superior Surge Suppressor, 10-Outlet, With Phone and Remote	Tanja Norvell	Home Office	2019-04-22	2019-04-29	Standard Class	23.56	5	7.0680
United States	Texas	Amarillo	Central	Furniture	Bookcases	Bush Mission Pointe Library	David Smith	Corporate	2020-03-31	2020-04-04	Standard Class	205.33	2	-36.2352
United States	Illinois	Chicago	Central	Office Supplies	Binders	Cardinal Hold-It CD Pocket	Craig Carreira	Consumer	2019-12-16	2019-12-20	Second Class	4.79	3	-7.9002
United States	California	Los Angeles	West	Technology	Phones	Cisco SPA525G2 IP Phone - Wireless	Kristen Hastings	Corporate	2019-07-12	2019-07-19	Standard Class	95.76	6	7.1820
United States	New York	Troy	East	Furniture	Furnishings	Electrix 20W Halogen Replacement Bulb for Zoom-In Desk Lamp	Jeremy Ellison	Consumer	2019-10-27	2019-11-02	Standard Class	40.20	3	19.2960
United States	New York	New York City	East	Office Supplies	Art	Prang Colored Pencils	John Grady	Corporate	2019-06-26	2019-07-02	Standard Class	14.70	5	6.6150
United States	New York	New York City	East	Office Supplies	Storage	Fellowes Strictly Business Drawer File, Letter/Legal Size	John Grady	Corporate	2019-06-26	2019-07-02	Standard Class	14.70	5	6.6150
United States	California	Los Angeles	West	Office Supplies	Labels	Alphabetical Labels for Top Tab Filing	Michelle Tran	Home Office	2020-06-10	2020-06-13	First Class	29.60	2	14.8000
United States	California	Los Angeles	West	Furniture	Bookcases	O'Sullivan Living Dimensions 2-Shelf Bookcases	Michelle Tran	Home Office	2020-06-10	2020-06-13	First Class	29.60	2	14.8000
United States	California	Los Angeles	West	Technology	Phones	iHome FM Clock Radio with Lightning Dock	Michelle Tran	Home Office	2020-06-10	2020-06-13	First Class	29.60	2	14.8000
United States	Washington	Seattle	West	Technology	Accessories	Sony Micro Vault Click 8 GB USB 2.0 Flash Drive	Sonia Sunley	Consumer	2019-05-09	2019-05-14	Standard Class	93.98	2	13.1572
United States	Tennessee	Memphis	South	Furniture	Tables	Balt Solid Wood Rectangular Table	Rose O'Brian	Consumer	2019-03-18	2019-03-21	Second Class	189.88	3	-94.9410
United States	California	Costa Mesa	West	Office Supplies	Binders	Clear Mylar Reinforcing Strips	Sanjit Chand	Consumer	2019-07-25	2019-07-31	Standard Class	119.62	8	40.3704
United States	California	Costa Mesa	West	Furniture	Furnishings	Howard Miller 14-1/2" Diameter Chrome Round Wall Clock	Sanjit Chand	Consumer	2019-07-25	2019-07-31	Standard Class	119.62	8	40.3704
United States	California	Costa Mesa	West	Furniture	Chairs	DMI Arturo Collection Mission-style Design Wood Chair	Sanjit Chand	Consumer	2019-07-25	2019-07-31	Standard Class	119.62	8	40.3704
United States	California	Costa Mesa	West	Furniture	Furnishings	Deflect-O Glasstique Clear Desk Accessories	Sanjit Chand	Consumer	2019-07-25	2019-07-31	Standard Class	119.62	8	40.3704
United States	Colorado	Parker	West	Office Supplies	Binders	Vinyl Sectional Post Binders	Maribeth Yedwab	Corporate	2019-05-30	2019-06-04	Standard Class	22.62	2	-15.0800
United States	Colorado	Parker	West	Office Supplies	Binders	GBC Standard Therm-A-Bind Covers	Maribeth Yedwab	Corporate	2019-05-30	2019-06-04	Standard Class	22.62	2	-15.0800
United States	Colorado	Parker	West	Furniture	Chairs	Global Troy Executive Leather Low-Back Tilter	Maribeth Yedwab	Corporate	2019-05-30	2019-06-04	Standard Class	22.62	2	-15.0800
United States	Colorado	Parker	West	Office Supplies	Binders	Storex Flexible Poly Binders with Double Pockets	Maribeth Yedwab	Corporate	2019-05-30	2019-06-04	Standard Class	22.62	2	-15.0800
United States	Colorado	Parker	West	Office Supplies	Paper	White Dual Perf Computer Printout Paper, 2700 Sheets, 1 Part, Heavyweight, 20 lbs., 14 7/8 x 11	Maribeth Yedwab	Corporate	2019-05-30	2019-06-04	Standard Class	22.62	2	-15.0800
United States	Ohio	Akron	East	Office Supplies	Binders	Avery Durable Slant Ring Binders, No Labels	Ed Braxton	Corporate	2020-11-12	2020-11-15	Second Class	15.92	5	5.3730
United States	Missouri	Gladstone	Central	Furniture	Furnishings	Executive Impressions Supervisor Wall Clock	Lynn Smith	Consumer	2020-11-26	2020-11-27	First Class	126.30	3	40.4160
United States	Missouri	Gladstone	Central	Technology	Accessories	SanDisk Cruzer 32 GB USB Flash Drive	Lynn Smith	Consumer	2020-11-26	2020-11-27	First Class	126.30	3	40.4160
United States	Ohio	Newark	East	Office Supplies	Art	Premium Writing Pencils, Soft, #2 by Central Association for the Blind	Luke Foster	Consumer	2019-10-20	2019-10-23	First Class	7.15	3	0.7152
United States	California	Los Angeles	West	Office Supplies	Art	Newell 327	Bradley Nguyen	Consumer	2020-12-21	2020-12-25	Standard Class	6.63	3	1.7901
United States	California	Los Angeles	West	Office Supplies	Art	Newell 317	Bradley Nguyen	Consumer	2020-12-21	2020-12-25	Standard Class	6.63	3	1.7901
United States	Montana	Great Falls	West	Technology	Copiers	Canon Image Class D660 Copier	Alan Dominguez	Home Office	2020-01-22	2020-01-27	Standard Class	2999.95	5	1379.9770
United States	Montana	Great Falls	West	Office Supplies	Storage	Advantus Rolling Storage Box	Alan Dominguez	Home Office	2020-01-22	2020-01-27	Standard Class	2999.95	5	1379.9770
United States	Montana	Great Falls	West	Office Supplies	Paper	Great White Multi-Use Recycled Paper (20Lb. and 84 Bright)	Alan Dominguez	Home Office	2020-01-22	2020-01-27	Standard Class	2999.95	5	1379.9770
United States	Montana	Great Falls	West	Office Supplies	Storage	Tennsco Single-Tier Lockers	Alan Dominguez	Home Office	2020-01-22	2020-01-27	Standard Class	2999.95	5	1379.9770
United States	Michigan	Detroit	Central	Furniture	Tables	Balt Solid Wood Rectangular Table	Matt Connell	Corporate	2020-01-23	2020-01-25	First Class	210.98	2	21.0980
United States	California	Los Angeles	West	Technology	Phones	Motorola HK250 Universal Bluetooth Headset	Logan Haushalter	Consumer	2019-05-21	2019-05-23	First Class	55.18	3	-12.4146
United States	California	Los Angeles	West	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	Logan Haushalter	Consumer	2019-05-21	2019-05-23	First Class	55.18	3	-12.4146
United States	Florida	Lakeland	South	Furniture	Chairs	Global Commerce Series High-Back Swivel/Tilt Chairs	Patricia Hirasaki	Home Office	2020-10-21	2020-10-26	Standard Class	683.95	3	42.7470
United States	Florida	Lakeland	South	Furniture	Furnishings	Eldon Expressions Desk Accessory, Wood Photo Frame, Mahogany	Patricia Hirasaki	Home Office	2020-10-21	2020-10-26	Standard Class	683.95	3	42.7470
United States	California	Los Angeles	West	Furniture	Furnishings	Tenex Chairmats For Use With Carpeted Floors	Jasper Cacioppo	Consumer	2020-09-07	2020-09-11	Standard Class	47.94	3	2.3970
United States	Alabama	Montgomery	South	Technology	Phones	Panasonic KX-TG9471B	Rob Lucas	Consumer	2019-05-29	2019-06-01	Second Class	979.95	5	274.3860
United States	Alabama	Montgomery	South	Office Supplies	Binders	Presstex Flexible Ring Binders	Rob Lucas	Consumer	2019-05-29	2019-06-01	Second Class	979.95	5	274.3860
United States	Arizona	Mesa	West	Office Supplies	Storage	Sterilite Officeware Hinged File Box	Allen Armold	Consumer	2019-07-10	2019-07-16	Standard Class	16.77	2	1.4672
United States	Illinois	Chicago	Central	Office Supplies	Binders	Premier Elliptical Ring Binder, Black	Emily Phan	Consumer	2020-09-03	2020-09-08	Second Class	42.62	7	-68.1856
United States	Florida	Melbourne	South	Technology	Phones	LG Electronics Tone+ HBS-730 Bluetooth Headset	Erin Smith	Corporate	2019-07-14	2019-07-17	First Class	380.86	8	38.0864
United States	New York	New York City	East	Office Supplies	Binders	Avery Printable Repositionable Plastic Tabs	Adrian Shami	Home Office	2020-11-19	2020-11-22	First Class	41.28	6	13.9320
United States	New York	New York City	East	Office Supplies	Paper	Xerox 1898	Adrian Shami	Home Office	2020-11-19	2020-11-22	First Class	41.28	6	13.9320
United States	California	San Francisco	West	Furniture	Chairs	HON 5400 Series Task Chairs for Big and Tall	Bill Donatelli	Consumer	2019-04-15	2019-04-17	Second Class	1121.57	2	0.0000
United States	Florida	Jacksonville	South	Furniture	Furnishings	Howard Miller 11-1/2" Diameter Grantwood Wall Clock	Ryan Crowe	Consumer	2020-09-11	2020-09-12	First Class	34.50	1	6.0382
United States	Minnesota	Lakeville	Central	Office Supplies	Fasteners	Advantus T-Pin Paper Clips	Greg Tran	Consumer	2020-11-24	2020-11-28	Standard Class	10.82	3	2.5707
United States	California	Anaheim	West	Office Supplies	Storage	Tennsco 16-Compartment Lockers with Coat Rack	Dean Katz	Corporate	2020-06-29	2020-07-03	Second Class	1295.78	2	310.9872
United States	California	Los Angeles	West	Office Supplies	Labels	Avery 473	Olvera Toch	Consumer	2019-06-10	2019-06-15	Standard Class	20.70	2	9.9360
United States	California	Los Angeles	West	Furniture	Tables	Bretford ?Just In Time? Height-Adjustable Multi-Task Work Tables	Olvera Toch	Consumer	2019-06-10	2019-06-15	Standard Class	20.70	2	9.9360
United States	California	Los Angeles	West	Office Supplies	Paper	Xerox 226	Olvera Toch	Consumer	2019-06-10	2019-06-15	Standard Class	20.70	2	9.9360
United States	California	San Francisco	West	Furniture	Furnishings	Coloredge Poster Frame	Liz Pelletier	Consumer	2020-11-20	2020-11-22	Second Class	42.60	3	16.6140
United States	California	San Francisco	West	Office Supplies	Binders	GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb	Liz Pelletier	Consumer	2020-11-20	2020-11-22	Second Class	42.60	3	16.6140
United States	California	Los Angeles	West	Technology	Phones	Cisco SPA301	Frank Preis	Consumer	2020-12-07	2020-12-10	First Class	374.38	3	46.7970
United States	Washington	Seattle	West	Office Supplies	Paper	Personal Creations Ink Jet Cards and Labels	Ellis Ballard	Corporate	2020-10-01	2020-10-08	Standard Class	91.84	8	45.0016
United States	Washington	Seattle	West	Office Supplies	Binders	GBC White Gloss Covers, Plain Front	Ellis Ballard	Corporate	2020-10-01	2020-10-08	Standard Class	91.84	8	45.0016
United States	Washington	Seattle	West	Office Supplies	Paper	Xerox 222	Ellis Ballard	Corporate	2020-10-01	2020-10-08	Standard Class	91.84	8	45.0016
United States	Washington	Seattle	West	Furniture	Chairs	Hon Every-Day Series Multi-Task Chairs	Ellis Ballard	Corporate	2020-10-01	2020-10-08	Standard Class	91.84	8	45.0016
United States	New York	New York City	East	Office Supplies	Labels	Avery 473	Jennifer Ferguson	Consumer	2020-12-28	2019-01-04	Standard Class	72.45	7	34.7760
United States	New York	New York City	East	Office Supplies	Fasteners	OIC Bulk Pack Metal Binder Clips	Jennifer Ferguson	Consumer	2020-12-28	2019-01-04	Standard Class	72.45	7	34.7760
United States	New York	New York City	East	Office Supplies	Binders	Storex Dura Pro Binders	Jennifer Ferguson	Consumer	2020-12-28	2019-01-04	Standard Class	72.45	7	34.7760
United States	New York	New York City	East	Technology	Phones	Cush Cases Heavy Duty Rugged Cover Case for Samsung Galaxy S5 - Purple	Jennifer Ferguson	Consumer	2020-12-28	2019-01-04	Standard Class	72.45	7	34.7760
United States	Washington	Marysville	West	Office Supplies	Art	Newell 332	Sarah Foster	Consumer	2019-11-03	2019-11-07	Standard Class	8.82	3	2.3814
United States	Illinois	Chicago	Central	Office Supplies	Storage	Trav-L-File Heavy-Duty Shuttle II, Black	Carlos Soltero	Consumer	2020-07-20	2020-07-26	Standard Class	69.71	2	8.7140
United States	Illinois	Chicago	Central	Furniture	Furnishings	Contract Clock, 14", Brown	Carlos Soltero	Consumer	2020-07-20	2020-07-26	Standard Class	69.71	2	8.7140
United States	Colorado	Denver	West	Technology	Phones	GE 30524EE4	Dianna Vittorini	Consumer	2020-12-01	2020-12-05	Standard Class	470.38	3	52.9173
United States	Colorado	Denver	West	Technology	Phones	AT&T SB67148 SynJ	Dianna Vittorini	Consumer	2020-12-01	2020-12-05	Standard Class	470.38	3	52.9173
United States	Colorado	Denver	West	Office Supplies	Appliances	Fellowes Basic Home/Office Series Surge Protectors	Dianna Vittorini	Consumer	2020-12-01	2020-12-05	Standard Class	470.38	3	52.9173
United States	Colorado	Denver	West	Office Supplies	Binders	Recycled Pressboard Report Cover with Reinforced Top Hinge	Dianna Vittorini	Consumer	2020-12-01	2020-12-05	Standard Class	470.38	3	52.9173
United States	Colorado	Denver	West	Technology	Phones	Jabra BIZ 2300 Duo QD Duo Corded�Headset	Dianna Vittorini	Consumer	2020-12-01	2020-12-05	Standard Class	470.38	3	52.9173
United States	Oregon	Salem	West	Technology	Phones	i.Sound Portable Power - 8000 mAh	Zuschuss Carroll	Consumer	2019-03-20	2019-03-24	Standard Class	84.78	2	-20.1362
United States	Oregon	Salem	West	Office Supplies	Paper	Xerox 225	Zuschuss Carroll	Consumer	2019-03-20	2019-03-24	Standard Class	84.78	2	-20.1362
United States	Oregon	Salem	West	Office Supplies	Binders	Clear Mylar Reinforcing Strips	Zuschuss Carroll	Consumer	2019-03-20	2019-03-24	Standard Class	84.78	2	-20.1362
United States	Oregon	Salem	West	Office Supplies	Paper	Xerox 1894	Zuschuss Carroll	Consumer	2019-03-20	2019-03-24	Standard Class	84.78	2	-20.1362
United States	Pennsylvania	Philadelphia	East	Office Supplies	Supplies	Acme Stainless Steel Office Snips	Theone Pippenger	Consumer	2019-07-14	2019-07-16	First Class	11.63	2	1.0178
United States	Pennsylvania	Philadelphia	East	Technology	Phones	Mophie Juice Pack Helium for iPhone	Chloris Kastensmidt	Consumer	2019-07-16	2019-07-21	Standard Class	143.98	3	-28.7964
United States	Pennsylvania	Philadelphia	East	Technology	Phones	GE 2-Jack Phone Line Splitter	Chloris Kastensmidt	Consumer	2019-07-16	2019-07-21	Standard Class	143.98	3	-28.7964
United States	Pennsylvania	Philadelphia	East	Office Supplies	Supplies	Acme Value Line Scissors	Chloris Kastensmidt	Consumer	2019-07-16	2019-07-21	Standard Class	143.98	3	-28.7964
United States	Florida	Jacksonville	South	Technology	Phones	Nortel Meridian M3904 Professional Digital phone	Nona Balk	Corporate	2019-04-28	2019-05-01	First Class	369.58	3	41.5773
United States	Florida	Jacksonville	South	Office Supplies	Labels	Avery 493	Nona Balk	Corporate	2019-04-28	2019-05-01	First Class	369.58	3	41.5773
United States	Pennsylvania	Philadelphia	East	Office Supplies	Paper	Xerox 1972	Giulietta Dortch	Corporate	2019-09-11	2019-09-13	Second Class	8.45	2	2.6400
United States	Pennsylvania	Philadelphia	East	Technology	Phones	Cisco 8x8 Inc. 6753i IP Business Phone System	Giulietta Dortch	Corporate	2019-09-11	2019-09-13	Second Class	8.45	2	2.6400
United States	Ohio	Grove City	East	Technology	Phones	PureGear Roll-On Screen Protector	Clytie Kelty	Consumer	2020-11-14	2020-11-17	Second Class	119.94	10	15.9920
United States	Ohio	Grove City	East	Office Supplies	Binders	Prestige Round Ring Binders	Clytie Kelty	Consumer	2020-11-14	2020-11-17	Second Class	119.94	10	15.9920
United States	New York	New York City	East	Furniture	Furnishings	DAX Metal Frame, Desktop, Stepped-Edge	Nat Gilpin	Corporate	2020-08-18	2020-08-23	Second Class	40.48	2	15.7872
United States	New York	New York City	East	Furniture	Furnishings	DAX Value U-Channel Document Frames, Easel Back	Nat Gilpin	Corporate	2020-08-18	2020-08-23	Second Class	40.48	2	15.7872
United States	New York	New York City	East	Office Supplies	Binders	Recycled Easel Ring Binders	Nat Gilpin	Corporate	2020-08-18	2020-08-23	Second Class	40.48	2	15.7872
United States	New York	New York City	East	Technology	Phones	Grandstream GXP1160 VoIP phone	Nat Gilpin	Corporate	2020-08-18	2020-08-23	Second Class	40.48	2	15.7872
United States	New York	New York City	East	Furniture	Furnishings	Seth Thomas 14" Putty-Colored Wall Clock	Nat Gilpin	Corporate	2020-08-18	2020-08-23	Second Class	40.48	2	15.7872
United States	Illinois	Chicago	Central	Furniture	Furnishings	Master Caster Door Stop, Brown	Meg O'Connel	Home Office	2020-09-15	2020-09-19	Standard Class	35.56	7	12.0904
United States	Washington	Seattle	West	Office Supplies	Appliances	Belkin Premiere Surge Master II 8-outlet surge protector	Annie Thurman	Consumer	2020-05-19	2020-05-23	Standard Class	97.16	2	28.1764
United States	California	San Francisco	West	Office Supplies	Binders	Acco Pressboard Covers with Storage Hooks, 9 1/2" x 11", Executive Red	Logan Currie	Consumer	2020-12-17	2020-12-21	Standard Class	15.24	5	5.1435
United States	California	San Francisco	West	Office Supplies	Paper	Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled	Logan Currie	Consumer	2020-12-17	2020-12-21	Standard Class	15.24	5	5.1435
United States	Illinois	Aurora	Central	Office Supplies	Storage	Tennsco Regal Shelving Units	Fred McMath	Consumer	2019-12-11	2019-12-13	Second Class	243.38	3	-51.7191
United States	Illinois	Aurora	Central	Technology	Accessories	Imation�32GB Pocket Pro USB 3.0�Flash Drive�- 32 GB - Black - 1 P ...	Fred McMath	Consumer	2019-12-11	2019-12-13	Second Class	243.38	3	-51.7191
United States	Illinois	Aurora	Central	Technology	Phones	Jabra SPEAK 410	Fred McMath	Consumer	2019-12-11	2019-12-13	Second Class	243.38	3	-51.7191
United States	Florida	Miami	South	Technology	Accessories	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 1/Pack	Brian Dahlen	Consumer	2020-09-24	2020-09-26	Second Class	17.88	3	2.4585
United States	Florida	Miami	South	Office Supplies	Labels	Dot Matrix Printer Tape Reel Labels, White, 5000/Box	Brian Dahlen	Consumer	2020-09-24	2020-09-26	Second Class	17.88	3	2.4585
United States	Illinois	Aurora	Central	Office Supplies	Binders	Premium Transparent Presentation Covers by GBC	Max Engle	Consumer	2019-08-15	2019-08-21	Standard Class	18.88	3	-13.8468
United States	Illinois	Aurora	Central	Office Supplies	Appliances	Tripp Lite TLP810NET Broadband Surge for Modem/Fax	Max Engle	Consumer	2019-08-15	2019-08-21	Standard Class	18.88	3	-13.8468
United States	California	Vallejo	West	Furniture	Furnishings	Luxo Professional Fluorescent Magnifier Lamp with Clamp-Mount Base	Rick Bensley	Home Office	2019-05-20	2019-05-25	Standard Class	1049.20	5	272.7920
United States	California	Vallejo	West	Office Supplies	Binders	Wilson Jones Turn Tabs Binder Tool for Ring Binders	Rick Bensley	Home Office	2019-05-20	2019-05-25	Standard Class	1049.20	5	272.7920
United States	Minnesota	Minneapolis	Central	Furniture	Furnishings	Eldon 200 Class Desk Accessories	Justin Deggeller	Corporate	2019-12-18	2019-12-22	Standard Class	18.84	3	6.0288
United States	California	Mission Viejo	West	Office Supplies	Storage	Economy Rollaway Files	John Lee	Consumer	2020-07-30	2020-08-03	Second Class	330.40	2	85.9040
United States	California	Mission Viejo	West	Office Supplies	Labels	Avery 480	John Lee	Consumer	2020-07-30	2020-08-03	Second Class	330.40	2	85.9040
United States	Michigan	Rochester Hills	Central	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	Sean Christensen	Consumer	2020-06-10	2020-06-15	Standard Class	132.52	4	54.3332
United States	Arizona	Scottsdale	West	Office Supplies	Paper	Xerox 1993	Tamara Willingham	Home Office	2020-07-21	2020-07-25	Standard Class	6.48	1	3.1752
United States	Indiana	Columbus	Central	Office Supplies	Appliances	Eureka The Boss Plus 12-Amp Hard Box Upright Vacuum, Red	Chuck Clark	Home Office	2020-12-30	2019-01-05	Standard Class	209.30	2	56.5110
United States	California	Inglewood	West	Office Supplies	Fasteners	Staples	Barry Blumstein	Corporate	2019-04-01	2019-04-08	Standard Class	31.56	5	9.8625
United States	California	Inglewood	West	Office Supplies	Appliances	Belkin F9H710-06 7 Outlet SurgeMaster Surge Protector	Barry Blumstein	Corporate	2019-04-01	2019-04-08	Standard Class	31.56	5	9.8625
United States	Washington	Vancouver	West	Furniture	Furnishings	3M Hangers With Command Adhesive	Anthony Rawles	Corporate	2019-12-11	2019-12-16	Second Class	14.80	4	6.0680
United States	Washington	Vancouver	West	Technology	Phones	AT&T TR1909W	Anthony Rawles	Corporate	2019-12-11	2019-12-16	Second Class	14.80	4	6.0680
United States	Washington	Vancouver	West	Technology	Accessories	First Data FD10 PIN Pad	Anthony Rawles	Corporate	2019-12-11	2019-12-16	Second Class	14.80	4	6.0680
United States	New York	New York City	East	Office Supplies	Paper	Snap-A-Way Black Print Carbonless Ruled Speed Letter, Triplicate	Steven Roelle	Home Office	2019-10-23	2019-10-29	Standard Class	379.40	10	178.3180
United States	Tennessee	Franklin	South	Office Supplies	Paper	Xerox 1943	Allen Rosenblatt	Corporate	2020-06-19	2020-06-23	Standard Class	97.82	2	45.9754
United States	Tennessee	Franklin	South	Technology	Accessories	Sony 16GB Class 10 Micro SDHC R40 Memory Card	Allen Rosenblatt	Corporate	2020-06-19	2020-06-23	Standard Class	97.82	2	45.9754
United States	Indiana	Columbus	Central	Office Supplies	Appliances	Tripp Lite Isotel 8 Ultra 8 Outlet Metal Surge	Craig Reiter	Consumer	2019-08-22	2019-08-28	Standard Class	113.55	2	8.5164
United States	Indiana	Columbus	Central	Office Supplies	Binders	Avery Durable Poly Binders	Craig Reiter	Consumer	2019-08-22	2019-08-28	Standard Class	113.55	2	8.5164
United States	Indiana	Columbus	Central	Office Supplies	Envelopes	Airmail Envelopes	Craig Reiter	Consumer	2019-08-22	2019-08-28	Standard Class	113.55	2	8.5164
United States	Illinois	Aurora	Central	Furniture	Chairs	Global Troy Executive Leather Low-Back Tilter	Eugene Hildebrand	Home Office	2019-09-19	2019-09-19	Same Day	701.37	2	-50.0980
United States	Illinois	Aurora	Central	Office Supplies	Binders	Avery Binding System Hidden Tab Executive Style Index Sets	Eugene Hildebrand	Home Office	2019-09-19	2019-09-19	Same Day	701.37	2	-50.0980
United States	New York	New York City	East	Office Supplies	Storage	Gould Plastics 18-Pocket Panel Bin, 34w x 5-1/4d x 20-1/2h	Sibella Parks	Corporate	2019-03-26	2019-03-30	Standard Class	459.95	5	18.3980
United States	Kentucky	Louisville	South	Office Supplies	Fasteners	OIC Colored Binder Clips, Assorted Sizes	Roy Collins	Consumer	2019-11-04	2019-11-04	Same Day	10.74	3	5.2626
United States	Texas	Dallas	Central	Office Supplies	Supplies	Acme Tagit Stainless Steel Antibacterial Scissors	Tiffany House	Corporate	2020-06-08	2020-06-10	Second Class	23.76	3	2.0790
United States	Texas	Dallas	Central	Office Supplies	Paper	Easy-staple paper	Tiffany House	Corporate	2020-06-08	2020-06-10	Second Class	23.76	3	2.0790
United States	Texas	Dallas	Central	Technology	Phones	ClearOne Communications CHAT 70 OC�Speaker Phone	Tiffany House	Corporate	2020-06-08	2020-06-10	Second Class	23.76	3	2.0790
United States	Illinois	Chicago	Central	Furniture	Furnishings	12-1/2 Diameter Round Wall Clock	Meg O'Connel	Home Office	2020-06-09	2020-06-13	Standard Class	23.98	3	-14.3856
United States	Illinois	Chicago	Central	Furniture	Tables	Chromcraft Bull-Nose Wood Round Conference Table Top, Wood Base	Meg O'Connel	Home Office	2020-06-09	2020-06-13	Standard Class	23.98	3	-14.3856
United States	Illinois	Chicago	Central	Office Supplies	Paper	Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages	Meg O'Connel	Home Office	2020-06-09	2020-06-13	Standard Class	23.98	3	-14.3856
United States	Massachusetts	Lowell	East	Office Supplies	Art	Newell 331	Tamara Dahlen	Consumer	2020-06-15	2020-06-22	Standard Class	19.56	5	1.7115
United States	Indiana	Columbus	Central	Office Supplies	Appliances	Kensington 6 Outlet Guardian Standard Surge Protector	Rob Beeghly	Consumer	2020-12-05	2020-12-08	First Class	61.44	3	16.5888
United States	Indiana	Columbus	Central	Office Supplies	Paper	Southworth 100% R�sum� Paper, 24lb.	Rob Beeghly	Consumer	2020-12-05	2020-12-08	First Class	61.44	3	16.5888
United States	Indiana	Columbus	Central	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	Rob Beeghly	Consumer	2020-12-05	2020-12-08	First Class	61.44	3	16.5888
United States	Texas	Tyler	Central	Office Supplies	Appliances	Hoover Portapower Portable Vacuum	Carol Darley	Consumer	2020-03-18	2020-03-23	Standard Class	2.69	3	-7.3920
United States	Texas	Tyler	Central	Technology	Accessories	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 10/Pack	Carol Darley	Consumer	2020-03-18	2020-03-23	Standard Class	2.69	3	-7.3920
United States	Texas	Tyler	Central	Furniture	Furnishings	Howard Miller 13-1/2" Diameter Rosebrook Wall Clock	Carol Darley	Consumer	2020-03-18	2020-03-23	Standard Class	2.69	3	-7.3920
United States	Texas	Tyler	Central	Office Supplies	Binders	Ibico Hi-Tech Manual Binding System	Carol Darley	Consumer	2020-03-18	2020-03-23	Standard Class	2.69	3	-7.3920
United States	New York	New York City	East	Office Supplies	Binders	Avery Hanging File Binders	Doug Jacobs	Consumer	2019-11-19	2019-11-24	Standard Class	14.35	3	4.6644
United States	New York	New York City	East	Office Supplies	Storage	Fellowes Neat Ideas Storage Cubes	Doug Jacobs	Consumer	2019-11-19	2019-11-24	Standard Class	14.35	3	4.6644
United States	New York	New York City	East	Office Supplies	Storage	Advantus Rolling Storage Box	Doug Jacobs	Consumer	2019-11-19	2019-11-24	Standard Class	14.35	3	4.6644
United States	North Carolina	Burlington	South	Technology	Machines	Cubify CubeX 3D Printer Triple Head Print	Grant Thornton	Corporate	2020-11-04	2020-11-04	Same Day	7999.98	4	-3839.9904
United States	North Carolina	Burlington	South	Office Supplies	Appliances	Eureka The Boss Plus 12-Amp Hard Box Upright Vacuum, Red	Grant Thornton	Corporate	2020-11-04	2020-11-04	Same Day	7999.98	4	-3839.9904
United States	New York	New York City	East	Furniture	Bookcases	Bush Andora Bookcase, Maple/Graphite Gray Finish	Ralph Arnett	Consumer	2020-12-25	2020-12-29	Standard Class	191.98	2	4.7996
United States	Ohio	Cleveland	East	Furniture	Furnishings	Eldon 200 Class Desk Accessories, Burgundy	Dorris liebe	Corporate	2020-09-02	2020-09-08	Standard Class	15.07	3	4.1448
United States	Washington	Seattle	West	Furniture	Furnishings	Tenex "The Solids" Textured Chair Mats	Alejandro Savely	Corporate	2019-11-04	2019-11-08	Second Class	209.88	3	35.6796
United States	Florida	Palm Coast	South	Office Supplies	Envelopes	#10- 4 1/8" x 9 1/2" Security-Tint Envelopes	Arthur Prichep	Consumer	2020-09-03	2020-09-07	Standard Class	24.45	4	8.8624
United States	New York	Mount Vernon	East	Office Supplies	Appliances	Bionaire Personal Warm Mist Humidifier/Vaporizer	Roland Schwarz	Corporate	2020-05-19	2020-05-24	Standard Class	281.34	6	109.7226
United States	New York	Mount Vernon	East	Technology	Phones	Nortel Meridian M3904 Professional Digital phone	Roland Schwarz	Corporate	2020-05-19	2020-05-24	Standard Class	281.34	6	109.7226
United States	New York	Mount Vernon	East	Technology	Accessories	Logitech Wireless Performance Mouse MX for PC and Mac	Roland Schwarz	Corporate	2020-05-19	2020-05-24	Standard Class	281.34	6	109.7226
United States	Ohio	Newark	East	Furniture	Furnishings	Howard Miller 13" Diameter Pewter Finish Round Wall Clock	Kelly Collister	Consumer	2020-09-24	2020-09-29	Standard Class	103.06	3	24.4758
United States	California	Los Angeles	West	Office Supplies	Paper	Tops Green Bar Computer Printout Paper	Ross DeVincentis	Home Office	2019-02-13	2019-02-18	Standard Class	146.82	3	73.4100
United States	Massachusetts	Lawrence	East	Furniture	Tables	Chromcraft Bull-Nose Wood Oval Conference Tables & Bases	Michael Paige	Corporate	2019-12-15	2019-12-19	Standard Class	1652.94	3	231.4116
United States	Massachusetts	Lawrence	East	Office Supplies	Storage	Recycled Data-Pak for Archival Bound Computer Printouts, 12-1/2 x 12-1/2 x 16	Michael Paige	Corporate	2019-12-15	2019-12-19	Standard Class	1652.94	3	231.4116
United States	Florida	Hialeah	South	Office Supplies	Supplies	Acme Softgrip Scissors	Steve Chapman	Corporate	2019-07-07	2019-07-12	Standard Class	45.58	7	5.1282
United States	Texas	Austin	Central	Office Supplies	Envelopes	Manila Recycled Extra-Heavyweight Clasp Envelopes, 6" x 9"	Jay Fein	Consumer	2020-09-16	2020-09-20	Standard Class	17.57	2	6.3684
United States	Texas	Austin	Central	Technology	Phones	ClearSounds CSC500 Amplified Spirit Phone Corded phone	Jay Fein	Consumer	2020-09-16	2020-09-20	Standard Class	17.57	2	6.3684
United States	New York	Oceanside	East	Office Supplies	Paper	Xerox 1964	Emily Grady	Consumer	2019-12-03	2019-12-06	First Class	182.72	8	84.0512
United States	New York	Oceanside	East	Furniture	Tables	Bevis Traditional Conference Table Top, Plinth Base	Emily Grady	Consumer	2019-12-03	2019-12-06	First Class	182.72	8	84.0512
United States	New York	Oceanside	East	Office Supplies	Storage	Personal Folder Holder, Ebony	Emily Grady	Consumer	2019-12-03	2019-12-06	First Class	182.72	8	84.0512
United States	New York	Oceanside	East	Furniture	Chairs	Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black	Emily Grady	Consumer	2019-12-03	2019-12-06	First Class	182.72	8	84.0512
United States	New York	Oceanside	East	Office Supplies	Labels	Avery 520	Emily Grady	Consumer	2019-12-03	2019-12-06	First Class	182.72	8	84.0512
United States	Washington	Seattle	West	Office Supplies	Storage	Carina Double Wide Media Storage Towers in Natural & Black	Darrin Sayre	Home Office	2020-01-21	2020-01-25	Standard Class	242.94	3	9.7176
United States	Washington	Seattle	West	Technology	Accessories	Logitech�Illuminated - Keyboard	Darrin Sayre	Home Office	2020-01-21	2020-01-25	Standard Class	242.94	3	9.7176
United States	Washington	Seattle	West	Office Supplies	Binders	Wilson Jones Century Plastic Molded Ring Binders	Darrin Sayre	Home Office	2020-01-21	2020-01-25	Standard Class	242.94	3	9.7176
United States	Washington	Seattle	West	Office Supplies	Binders	Wilson Jones Leather-Like Binders with DublLock Round Rings	Darrin Sayre	Home Office	2020-01-21	2020-01-25	Standard Class	242.94	3	9.7176
United States	Washington	Seattle	West	Furniture	Bookcases	O'Sullivan Cherrywood Estates Traditional Bookcase	Darrin Sayre	Home Office	2020-01-21	2020-01-25	Standard Class	242.94	3	9.7176
United States	Washington	Seattle	West	Office Supplies	Binders	Acco Translucent Poly Ring Binders	Darrin Sayre	Home Office	2020-01-21	2020-01-25	Standard Class	242.94	3	9.7176
United States	Texas	Dallas	Central	Office Supplies	Supplies	Martin-Yale Premier Letter Opener	Sung Shariari	Consumer	2019-08-27	2019-09-01	Standard Class	51.52	5	-10.9480
United States	Texas	Dallas	Central	Office Supplies	Paper	Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled	Sung Shariari	Consumer	2019-08-27	2019-09-01	Standard Class	51.52	5	-10.9480
United States	Texas	Dallas	Central	Office Supplies	Paper	Xerox 196	Sung Shariari	Consumer	2019-08-27	2019-09-01	Standard Class	51.52	5	-10.9480
United States	Texas	Dallas	Central	Office Supplies	Supplies	Fiskars 8" Scissors, 2/Pack	Sung Shariari	Consumer	2019-08-27	2019-09-01	Standard Class	51.52	5	-10.9480
United States	Illinois	Evanston	Central	Technology	Phones	Belkin iPhone and iPad Lightning Cable	Peter B�hler	Consumer	2019-03-20	2019-03-22	Second Class	11.99	1	0.8994
United States	Michigan	Trenton	Central	Office Supplies	Binders	GBC Durable Plastic Covers	Roland Fjeld	Consumer	2020-10-02	2020-10-06	Standard Class	58.05	3	26.7030
United States	Michigan	Trenton	Central	Furniture	Furnishings	Nu-Dell Leatherette Frames	Roland Fjeld	Consumer	2020-10-02	2020-10-06	Standard Class	58.05	3	26.7030
United States	Michigan	Trenton	Central	Office Supplies	Art	Avery Hi-Liter EverBold Pen Style Fluorescent Highlighters, 4/Pack	Roland Fjeld	Consumer	2020-10-02	2020-10-06	Standard Class	58.05	3	26.7030
United States	Michigan	Trenton	Central	Office Supplies	Binders	Avery Durable Binders	Roland Fjeld	Consumer	2020-10-02	2020-10-06	Standard Class	58.05	3	26.7030
United States	California	San Francisco	West	Technology	Copiers	Hewlett Packard 610 Color Digital Copier / Printer	Yoseph Carroll	Corporate	2019-04-07	2019-04-09	First Class	1199.98	3	374.9925
United States	Florida	Jacksonville	South	Furniture	Tables	Chromcraft Round Conference Tables	Nona Balk	Corporate	2019-09-18	2019-09-22	Standard Class	383.44	4	-167.3184
United States	New York	New York City	East	Office Supplies	Binders	Angle-D Ring Binders	Christine Phan	Corporate	2020-07-23	2020-07-28	Standard Class	13.13	3	4.2666
United States	Wisconsin	Green Bay	Central	Office Supplies	Paper	Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages	Barry Franz�sisch	Corporate	2020-09-18	2020-09-22	Standard Class	22.72	4	10.2240
United States	Georgia	Atlanta	South	Office Supplies	Labels	Avery 476	Julie Creighton	Corporate	2020-11-03	2020-11-07	Standard Class	12.39	3	5.6994
United States	California	Whittier	West	Furniture	Chairs	Hon 4070 Series Pagoda Round Back Stacking Chairs	Laurel Elliston	Consumer	2019-05-19	2019-05-24	Standard Class	641.96	2	179.7488
United States	Iowa	Des Moines	Central	Office Supplies	Binders	Cardinal EasyOpen D-Ring Binders	Benjamin Venier	Corporate	2020-01-30	2020-02-05	Standard Class	18.28	2	9.1400
United States	Iowa	Des Moines	Central	Technology	Phones	AT&T 841000 Phone	Benjamin Venier	Corporate	2020-01-30	2020-02-05	Standard Class	18.28	2	9.1400
United States	Iowa	Des Moines	Central	Office Supplies	Binders	GBC Instant Report Kit	Benjamin Venier	Corporate	2020-01-30	2020-02-05	Standard Class	18.28	2	9.1400
United States	Iowa	Des Moines	Central	Office Supplies	Binders	DXL Angle-View Binders with Locking Rings by Samsill	Benjamin Venier	Corporate	2020-01-30	2020-02-05	Standard Class	18.28	2	9.1400
United States	Iowa	Des Moines	Central	Office Supplies	Art	Boston 19500 Mighty Mite Electric Pencil Sharpener	Benjamin Venier	Corporate	2020-01-30	2020-02-05	Standard Class	18.28	2	9.1400
United States	Iowa	Des Moines	Central	Furniture	Furnishings	C-Line Magnetic Cubicle Keepers, Clear Polypropylene	Benjamin Venier	Corporate	2020-01-30	2020-02-05	Standard Class	18.28	2	9.1400
United States	California	Lancaster	West	Office Supplies	Binders	Heavy-Duty E-Z-D Binders	Clay Ludtke	Consumer	2020-03-17	2020-03-21	Second Class	17.46	2	5.8914
United States	North Carolina	Asheville	South	Technology	Phones	Cisco Unified IP Phone 7945G VoIP phone	Joe Kamberova	Consumer	2019-05-20	2019-05-20	Same Day	1363.96	5	85.2475
United States	Minnesota	Rochester	Central	Office Supplies	Binders	Avery Durable Binders	Rick Hansen	Consumer	2020-09-21	2020-09-26	Standard Class	20.16	7	9.8784
United States	California	San Diego	West	Furniture	Furnishings	Executive Impressions 14" Contract Wall Clock	Helen Wasserman	Corporate	2020-02-20	2020-02-23	First Class	22.23	1	7.3359
United States	California	San Diego	West	Technology	Phones	Logitech Mobile Speakerphone P710e -�speaker phone	Helen Wasserman	Corporate	2020-02-20	2020-02-23	First Class	22.23	1	7.3359
United States	California	San Diego	West	Office Supplies	Appliances	Belkin 7 Outlet SurgeMaster II	Helen Wasserman	Corporate	2019-08-18	2019-08-23	Second Class	355.32	9	99.4896
United States	Louisiana	Monroe	South	Office Supplies	Paper	Xerox 218	Mike Caudle	Corporate	2019-03-12	2019-03-17	Standard Class	12.96	2	6.2208
United States	California	San Francisco	West	Furniture	Furnishings	Eldon Stackable Tray, Side-Load, Legal, Smoke	Gary McGarr	Consumer	2020-04-22	2020-04-24	First Class	18.28	2	6.2152
United States	California	Santa Ana	West	Furniture	Furnishings	Eldon Stackable Tray, Side-Load, Legal, Smoke	Pauline Johnson	Consumer	2020-05-14	2020-05-14	Same Day	18.28	2	6.2152
United States	California	Santa Ana	West	Technology	Accessories	Razer Tiamat Over Ear 7.1 Surround Sound PC Gaming Headset	Pauline Johnson	Consumer	2020-05-14	2020-05-14	Same Day	18.28	2	6.2152
United States	Pennsylvania	Philadelphia	East	Office Supplies	Paper	Xerox 1968	Dean Braden	Consumer	2019-09-15	2019-09-19	Standard Class	5.34	1	1.8704
United States	New Jersey	Belleville	East	Technology	Accessories	Razer Kraken PRO Over Ear PC and Music Headset	Toby Ritter	Consumer	2020-06-20	2020-06-27	Standard Class	239.97	3	71.9910
United States	New Jersey	Belleville	East	Office Supplies	Labels	Avery 508	Toby Ritter	Consumer	2020-06-20	2020-06-27	Standard Class	239.97	3	71.9910
United States	Minnesota	Lakeville	Central	Office Supplies	Fasteners	Advantus Plastic Paper Clips	Greg Tran	Consumer	2020-08-21	2020-08-28	Standard Class	35.00	7	16.8000
United States	Minnesota	Lakeville	Central	Office Supplies	Supplies	Acme Forged Steel Scissors with Black Enamel Handles	Greg Tran	Consumer	2020-08-21	2020-08-28	Standard Class	35.00	7	16.8000
United States	Minnesota	Lakeville	Central	Office Supplies	Envelopes	Security-Tint Envelopes	Greg Tran	Consumer	2020-08-21	2020-08-28	Standard Class	35.00	7	16.8000
United States	Kentucky	Florence	South	Furniture	Chairs	Global Airflow Leather Mesh Back Chair, Black	Joel Eaton	Consumer	2020-06-16	2020-06-21	Second Class	301.96	2	90.5880
United States	Kentucky	Florence	South	Office Supplies	Appliances	Fellowes Smart Surge Ten-Outlet Protector, Platinum	Joel Eaton	Consumer	2020-06-16	2020-06-21	Second Class	301.96	2	90.5880
United States	Kentucky	Florence	South	Technology	Phones	Pyle PMP37LED	Joel Eaton	Consumer	2020-06-16	2020-06-21	Second Class	301.96	2	90.5880
United States	Kentucky	Florence	South	Technology	Phones	Clarity 53712	Joel Eaton	Consumer	2020-06-16	2020-06-21	Second Class	301.96	2	90.5880
United States	Florida	Tampa	South	Office Supplies	Art	Boston 16801 Nautilus Battery Pencil Sharpener	Jennifer Braxton	Corporate	2019-07-23	2019-07-27	Standard Class	35.22	2	2.6412
United States	Florida	Tampa	South	Office Supplies	Appliances	Holmes Replacement Filter for HEPA Air Cleaner, Large Room	Jennifer Braxton	Corporate	2019-07-23	2019-07-27	Standard Class	35.22	2	2.6412
United States	Florida	Tampa	South	Technology	Machines	Zebra GX420t Direct Thermal/Thermal Transfer Printer	Jennifer Braxton	Corporate	2019-07-23	2019-07-27	Standard Class	35.22	2	2.6412
United States	South Carolina	Columbia	South	Office Supplies	Paper	Adams Telephone Message Books, 5 1/4? x 11?	James Lanier	Home Office	2020-11-04	2020-11-11	Standard Class	9.66	2	3.2616
United States	Ohio	Akron	East	Technology	Phones	Belkin Grip Candy Sheer Case / Cover for iPhone 5 and 5S	Ed Braxton	Corporate	2019-03-07	2019-03-12	Standard Class	21.07	3	1.5804
United States	California	Los Angeles	West	Office Supplies	Binders	Fellowes Binding Cases	Eudokia Martin	Corporate	2019-11-07	2019-11-09	First Class	37.44	4	11.7000
United States	California	Los Angeles	West	Office Supplies	Binders	Ibico Plastic and Wire Spiral Binding Combs	Eudokia Martin	Corporate	2019-11-07	2019-11-09	First Class	37.44	4	11.7000
United States	California	Los Angeles	West	Office Supplies	Supplies	Acme Preferred Stainless Steel Scissors	Eudokia Martin	Corporate	2019-11-07	2019-11-09	First Class	37.44	4	11.7000
United States	California	Los Angeles	West	Office Supplies	Labels	Avery 486	Eudokia Martin	Corporate	2019-11-07	2019-11-09	First Class	37.44	4	11.7000
United States	Ohio	Lorain	East	Furniture	Furnishings	Linden 10" Round Wall Clock, Black	Guy Armstrong	Consumer	2020-01-01	2020-01-06	Standard Class	48.90	4	8.5568
United States	California	Salinas	West	Office Supplies	Art	DIXON Oriole Pencils	Dave Poirier	Corporate	2019-06-20	2019-06-25	Second Class	5.16	2	1.3416
United States	California	Salinas	West	Office Supplies	Paper	Xerox 202	Dave Poirier	Corporate	2019-06-20	2019-06-25	Second Class	5.16	2	1.3416
United States	Mississippi	Jackson	South	Office Supplies	Art	Boston School Pro Electric Pencil Sharpener, 1670	Valerie Dominguez	Consumer	2019-05-28	2019-06-04	Standard Class	185.88	6	50.1876
United States	Minnesota	Lakeville	Central	Furniture	Furnishings	Executive Impressions 14" Contract Wall Clock	Greg Tran	Consumer	2019-02-19	2019-02-24	Standard Class	44.46	2	14.6718
United States	Minnesota	Lakeville	Central	Office Supplies	Storage	Carina Double Wide Media Storage Towers in Natural & Black	Greg Tran	Consumer	2019-02-19	2019-02-24	Standard Class	44.46	2	14.6718
United States	New Jersey	New Brunswick	East	Office Supplies	Paper	Wirebound Message Books, Two 4 1/4" x 5" Forms per Page	Sanjit Jacobs	Home Office	2020-04-10	2020-04-15	Standard Class	7.61	1	3.5767
United States	New Jersey	New Brunswick	East	Office Supplies	Fasteners	OIC Binder Clips	Sanjit Jacobs	Home Office	2020-04-10	2020-04-15	Standard Class	7.61	1	3.5767
United States	Florida	Jacksonville	South	Technology	Accessories	Logitech�MX Performance Wireless Mouse	Anthony Johnson	Corporate	2019-01-05	2019-01-07	Second Class	191.47	6	40.6878
United States	Florida	Jacksonville	South	Office Supplies	Art	Newell 337	Anthony Johnson	Corporate	2019-01-05	2019-01-07	Second Class	191.47	6	40.6878
United States	Florida	Jacksonville	South	Technology	Phones	Logitech B530 USB�Headset�-�headset�- Full size, Binaural	Anthony Johnson	Corporate	2019-01-05	2019-01-07	Second Class	191.47	6	40.6878
United States	Pennsylvania	Philadelphia	East	Office Supplies	Labels	Avery 483	Linda Southworth	Corporate	2019-09-29	2019-10-02	First Class	15.94	4	5.1792
United States	Pennsylvania	Philadelphia	East	Office Supplies	Binders	GBC Ibimaster 500 Manual ProClick Binding System	Paul Knutson	Home Office	2019-09-03	2019-09-05	First Class	1141.47	5	-760.9800
United States	Pennsylvania	Philadelphia	East	Technology	Phones	Cisco SPA301	Paul Knutson	Home Office	2019-09-03	2019-09-05	First Class	1141.47	5	-760.9800
United States	Ohio	Lorain	East	Office Supplies	Paper	Xerox 1910	Guy Armstrong	Consumer	2020-08-25	2020-08-29	Standard Class	192.16	5	67.2560
United States	Indiana	Columbus	Central	Furniture	Furnishings	Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39" x 49"	Chuck Clark	Home Office	2019-01-17	2019-01-21	Standard Class	322.59	3	64.5180
United States	Indiana	Columbus	Central	Technology	Accessories	Logitech 910-002974 M325 Wireless Mouse for Web Scrolling	Chuck Clark	Home Office	2019-01-17	2019-01-21	Standard Class	322.59	3	64.5180
United States	Indiana	Columbus	Central	Technology	Accessories	Logitech G19 Programmable Gaming Keyboard	Chuck Clark	Home Office	2019-01-17	2019-01-21	Standard Class	322.59	3	64.5180
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (categoryid, categoryname) FROM stdin;
1	\N
2	Furniture
3	Office Supplies
4	Technology
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (cityid, cityname, stateid) FROM stdin;
1	Great Falls	34
2	Las Vegas	35
3	Tampa	21
4	Troy	36
5	Fremont	22
6	Norman	6
7	Dover	3
8	Gastonia	13
9	Columbus	23
10	Parker	37
11	Dallas	31
12	Monroe	15
13	Saint Paul	26
14	Grove City	4
15	Edmond	6
16	Louisville	9
17	Los Angeles	8
18	New York City	36
19	Montgomery	17
20	San Diego	8
21	Evanston	12
22	Newark	4
23	Lorain	4
24	Rochester Hills	14
25	Trenton	14
26	Mesa	27
27	Tyler	31
28	Hesperia	8
29	Lancaster	8
30	Concord	25
31	Tamarac	21
32	Richmond	9
33	Eagan	26
34	Grand Prairie	31
35	Jackson	16
36	Asheville	13
37	Arlington	32
38	Inglewood	8
39	Decatur	17
40	Quincy	12
41	Philadelphia	10
42	Aurora	12
43	Jackson	14
44	Huntington Beach	8
45	Morristown	30
46	Murfreesboro	18
47	Auburn	36
48	Charlotte	13
49	Carlsbad	11
50	Naperville	12
51	Salinas	8
52	Cleveland	4
53	Jacksonville	21
54	Fort Worth	31
55	Warwick	20
56	Santa Clara	8
57	Austin	31
58	Canton	14
59	Atlanta	19
60	Houston	31
61	Scottsdale	27
62	Whittier	8
63	Aurora	37
64	New Brunswick	30
65	Sierra Vista	27
66	Hialeah	21
67	Portland	5
68	Rochester	26
69	Denver	37
70	Columbus	19
71	Gladstone	28
72	Westfield	30
73	Akron	4
74	Amarillo	31
75	Mount Vernon	36
76	Burlington	13
77	Santa Ana	8
78	Franklin	18
79	Phoenix	27
80	Fairfield	2
81	Plainfield	30
82	Minneapolis	26
83	Detroit	14
84	Franklin	7
85	Decatur	12
86	Oceanside	36
87	Urbandale	24
88	Seattle	1
89	Costa Mesa	8
90	Concord	13
91	Harlingen	31
92	Franklin	29
93	Roseville	8
94	Vallejo	8
95	Wilmington	3
96	Miami	21
97	Salem	5
98	Mission Viejo	8
99	Independence	28
100	Tucson	27
101	Chapel Hill	13
102	Columbus	4
103	Lowell	7
104	Belleville	30
105	Green Bay	29
106	Columbia	33
107	Des Moines	24
108	San Antonio	31
109	Manchester	2
110	Chicago	12
111	Marysville	1
112	Springfield	32
113	San Francisco	8
114	Melbourne	21
115	Columbia	18
116	Lakeville	26
117	Palm Coast	21
118	Lakeland	21
119	Henderson	9
120	Memphis	18
121	Pasadena	31
122	Lawrence	7
123	Cincinnati	4
124	Saginaw	14
125	Vancouver	1
126	Arvada	37
127	Florence	9
128	Anaheim	8
129	Richardson	31
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (countryid, countryname) FROM stdin;
1	United States
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customerid, customername, segmentid, countryid, stateid, cityid) FROM stdin;
AA-10375	Allen Armold	3	1	27	26
AA-10480	Andrew Allen	3	1	13	30
AB-10060	Adam Bellavance	1	1	36	18
AD-10180	Alan Dominguez	1	1	34	1
AG-10495	Andrew Gjertsen	4	1	10	41
AG-10675	Anna Gayman	3	1	31	60
AH-10195	Alan Haines	4	1	21	31
AJ-10795	Anthony Johnson	4	1	21	53
AM-10360	Alice McCarthy	4	1	31	34
AP-10915	Arthur Prichep	3	1	21	117
AR-10405	Allen Rosenblatt	4	1	7	78
AR-10825	Anthony Rawles	4	1	1	125
AS-10135	Adrian Shami	1	1	36	18
AS-10285	Alejandro Savely	4	1	1	88
AT-10735	Annie Thurman	3	1	1	88
BB-10990	Barry Blumstein	4	1	8	38
BB-11545	Brenda Bowman	4	1	31	60
BD-11320	Bill Donatelli	3	1	8	113
BD-11605	Brian Dahlen	3	1	21	96
BF-11020	Barry Franz�sisch	4	1	29	105
BN-11515	Bradley Nguyen	3	1	8	17
BP-11185	Ben Peterman	4	1	37	126
BV-11245	Benjamin Venier	4	1	24	107
CA-12310	Christine Abelman	4	1	4	123
CB-12535	Claudia Bergmann	4	1	13	101
CC-12430	Chuck Clark	1	1	23	9
CC-12550	Clay Cheatham	3	1	8	113
CC-12670	Craig Carreira	3	1	12	110
CD-11980	Carol Darley	3	1	31	27
CG-12520	Claire Gute	3	1	9	119
CJ-12010	Caroline Jumper	3	1	8	44
CK-12205	Chloris Kastensmidt	3	1	10	41
CK-12595	Clytie Kelty	3	1	4	14
CL-12565	Clay Ludtke	3	1	8	29
CP-12340	Christine Phan	4	1	36	18
CR-12730	Craig Reiter	3	1	4	9
CS-11950	Carlos Soltero	3	1	12	110
CS-12400	Christopher Schild	1	1	12	110
CV-12805	Cynthia Voltz	4	1	36	18
DB-13060	Dave Brooks	3	1	7	103
DB-13120	David Bremer	4	1	8	56
DB-13210	Dean Braden	3	1	10	41
DJ-13510	Don Jones	4	1	18	46
DJ-13630	Doug Jacobs	3	1	36	18
DK-13225	Dean Katz	4	1	8	128
DL-13315	Delfina Latchford	3	1	36	18
Dl-13600	Dorris liebe	4	1	4	52
DP-13105	Dave Poirier	4	1	8	51
DS-13030	Darrin Sayre	1	1	1	88
DS-13180	David Smith	4	1	31	74
DV-13045	Darrin Van Huff	4	1	8	17
DV-13465	Dianna Vittorini	3	1	37	69
DW-13585	Dorothy Wardle	4	1	4	9
EB-13705	Ed Braxton	4	1	4	73
EB-13840	Ellis Ballard	4	1	1	88
EG-13900	Emily Grady	3	1	36	86
EH-13945	Eric Hoffmann	3	1	8	17
EH-14125	Eugene Hildebrand	1	1	12	42
EM-14095	Eudokia Martin	4	1	8	17
EP-13915	Emily Phan	3	1	12	110
ER-13855	Elpida Rittenbach	4	1	26	13
ES-14080	Erin Smith	4	1	21	114
FH-14365	Fred Hopkins	4	1	10	41
FM-14380	Fred McMath	3	1	37	42
FP-14320	Frank Preis	3	1	8	17
GA-14725	Guy Armstrong	3	1	4	23
GD-14590	Giulietta Dortch	4	1	10	41
GH-14485	Gene Hale	4	1	31	129
GK-14620	Grace Kelly	4	1	8	28
GM-14440	Gary McGarr	3	1	8	113
GM-14455	Gary Mitchum	1	1	31	60
GT-14635	Grant Thornton	4	1	13	76
GT-14710	Greg Tran	3	1	26	116
GT-14755	Guy Thornton	3	1	31	91
GZ-14470	Gary Zandusky	3	1	26	68
HK-14890	Heather Kirkland	4	1	13	48
HM-14980	Henry MacAllister	3	1	36	18
HW-14935	Helen Wasserman	4	1	8	20
IM-15070	Irene Maddox	3	1	1	88
JB-15400	Jennifer Braxton	4	1	21	3
JC-15340	Jasper Cacioppo	3	1	8	17
JC-16105	Julie Creighton	4	1	19	59
JD-15895	Jonathan Doherty	4	1	10	41
JD-16150	Justin Deggeller	4	1	26	82
JE-15475	Jeremy Ellison	3	1	36	4
JE-15745	Joel Eaton	3	1	9	127
JE-16165	Justin Ellison	4	1	29	78
JF-15355	Jay Fein	3	1	31	57
JF-15415	Jennifer Ferguson	3	1	36	18
JG-15805	John Grady	4	1	36	18
JH-15910	Jonathan Howell	3	1	8	17
JH-15985	Joseph Holt	3	1	14	124
JK-15730	Joe Kamberova	3	1	13	36
JL-15175	James Lanier	1	1	18	106
JL-15505	Jeremy Lonsdale	3	1	36	18
JL-15835	John Lee	3	1	8	98
JL-15850	John Lucas	3	1	10	41
JM-15250	Janet Martin	3	1	13	48
JM-15265	Janet Molinari	4	1	14	58
JS-15685	Jim Sink	4	1	8	17
KB-16585	Ken Black	4	1	22	5
KB-16600	Ken Brennan	4	1	31	60
KC-16540	Kelly Collister	3	1	4	22
KC-16675	Kimberly Carter	4	1	1	88
KD-16270	Karen Daniels	3	1	32	112
KD-16345	Katherine Ducich	3	1	8	113
KH-16510	Keith Herrera	3	1	8	113
KH-16630	Ken Heidel	4	1	6	6
KH-16690	Kristen Hastings	4	1	8	17
KL-16645	Ken Lonsdale	3	1	12	110
KW-16435	Katrina Willman	3	1	36	18
LC-16885	Lena Creighton	3	1	8	93
LC-16930	Linda Cazamias	4	1	12	50
LC-17140	Logan Currie	3	1	8	113
LE-16810	Laurel Elliston	3	1	8	62
LF-17185	Luke Foster	3	1	4	22
LH-16900	Lena Hernandez	3	1	3	7
LH-17155	Logan Haushalter	3	1	8	17
LP-17080	Liz Pelletier	3	1	8	113
LS-16945	Linda Southworth	4	1	10	41
LS-16975	Lindsay Shagiari	1	1	8	17
LS-17245	Lynn Smith	3	1	28	71
MA-17560	Matt Abelman	1	1	31	60
MB-17305	Maria Bertelson	3	1	4	73
MC-17605	Matt Connell	4	1	14	83
MC-18130	Mike Caudle	4	1	15	12
ME-17725	Max Engle	3	1	37	42
MJ-17740	Max Jones	3	1	1	88
MK-17905	Michael Kennedy	4	1	2	109
MM-18280	Muhammed MacIntyre	4	1	12	40
MO-17800	Meg O'Connel	1	1	12	110
MP-17965	Michael Paige	4	1	7	122
MT-18070	Michelle Tran	1	1	8	17
MV-18190	Mike Vittorini	3	1	36	18
MY-17380	Maribeth Yedwab	4	1	37	10
NB-18655	Nona Balk	4	1	21	53
NF-18385	Natalie Fritzler	3	1	12	39
NG-18355	Nat Gilpin	4	1	36	18
NP-18670	Nora Paige	3	1	6	15
NZ-18565	Nick Zandusky	1	1	4	9
ON-18715	Odella Nelson	4	1	26	33
OT-18730	Olvera Toch	3	1	8	17
PB-19105	Peter B�hler	3	1	12	21
PB-19150	Philip Brown	3	1	8	17
PG-18895	Paul Gonzalez	3	1	26	68
PH-18790	Patricia Hirasaki	1	1	21	118
PJ-19015	Pauline Johnson	3	1	8	77
PK-18910	Paul Knutson	1	1	10	41
PK-19075	Pete Kriz	3	1	14	83
PN-18775	Parhena Norris	1	1	36	18
PO-18850	Patrick O'Brill	3	1	10	41
PO-18865	Patrick O'Donnell	3	1	33	106
PO-19180	Philisse Overcash	1	1	12	110
RA-19285	Ralph Arnett	3	1	36	18
RA-19885	Ruben Ausman	4	1	8	17
RB-19360	Raymond Buch	3	1	36	47
RB-19465	Rick Bensley	1	1	8	94
RB-19570	Rob Beeghly	3	1	23	9
RB-19705	Roger Barcio	1	1	5	67
RB-19795	Ross Baird	1	1	13	8
RC-19825	Roy Collins	3	1	9	16
RC-19960	Ryan Crowe	3	1	21	53
RD-19810	Ross DeVincentis	1	1	8	17
RD-19900	Ruben Dartt	3	1	11	49
RF-19735	Roland Fjeld	3	1	14	25
RF-19840	Roy Franz�sisch	3	1	36	18
RH-19495	Rick Hansen	3	1	26	68
RL-19615	Rob Lucas	3	1	17	19
RO-19780	Rose O'Brian	3	1	18	120
RS-19765	Roland Schwarz	4	1	36	75
SC-20095	Sanjit Chand	3	1	8	89
SC-20305	Sean Christensen	3	1	14	24
SC-20695	Steve Chapman	4	1	21	66
SC-20725	Steven Cartwright	3	1	3	95
SC-20770	Stewart Carmichael	4	1	17	39
SF-20065	Sandra Flanagan	3	1	10	41
SF-20200	Sarah Foster	3	1	1	111
SG-20080	Sandra Glassco	3	1	28	99
SH-19975	Sally Hughsby	4	1	8	113
SH-20395	Shahid Hopkins	3	1	32	37
SJ-20125	Sanjit Jacobs	1	1	30	64
SJ-20500	Shirley Jackson	3	1	31	60
SK-19990	Sally Knutson	3	1	2	80
SP-20545	Sibella Parks	4	1	36	18
SP-20860	Sung Pak	4	1	8	17
SR-20740	Steven Roelle	1	1	36	18
SS-20140	Saphhira Shifley	4	1	20	55
SS-20590	Sonia Sunley	3	1	1	88
SS-20875	Sung Shariari	3	1	31	11
TB-21055	Ted Butterfield	3	1	36	4
TB-21520	Tracy Blumstein	3	1	14	35
TB-21595	Troy Blackwell	3	1	23	9
TD-20995	Tamara Dahlen	3	1	7	103
TH-21235	Tiffany House	4	1	31	11
TN-21040	Tanja Norvell	1	1	27	79
TP-21130	Theone Pippenger	3	1	10	41
TR-21325	Toby Ritter	3	1	30	104
TS-21610	Troy Staebel	3	1	27	79
TT-21070	Ted Trevino	3	1	8	17
TW-21025	Tamara Willingham	1	1	27	61
VB-21745	Victoria Brennan	4	1	9	32
VD-21670	Valerie Dominguez	3	1	16	35
VM-21685	Valerie Mitchum	1	1	30	72
VP-21730	Victor Preis	1	1	35	2
YC-21895	Yoseph Carroll	4	1	8	113
ZC-21910	Zuschuss Carroll	3	1	5	97
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (orderid, orderdate, shipdate, shipmode, customerid, sales, quantity, profit) FROM stdin;
CA-2019-152156	2019-11-08	2019-11-11	Second Class	CG-12520	261.96	2	41.9136
CA-2019-138688	2019-06-12	2019-06-16	Second Class	DV-13045	14.62	2	6.8714
CA-2020-114412	2020-04-15	2020-04-20	Standard Class	AA-10480	15.55	3	5.4432
CA-2019-161389	2019-12-05	2019-12-10	Standard Class	IM-15070	407.98	3	132.5922
CA-2019-137330	2019-12-09	2019-12-13	Standard Class	KB-16585	19.46	7	5.0596
US-2020-156909	2020-07-16	2020-07-18	Second Class	SF-20065	71.37	2	-1.0196
CA-2019-121755	2019-01-16	2019-01-20	Second Class	EH-13945	11.65	2	4.2224
CA-2020-107727	2020-10-19	2020-10-23	Second Class	MA-17560	29.47	3	9.9468
CA-2019-117590	2019-12-08	2019-12-10	First Class	GH-14485	1097.54	7	123.4737
CA-2020-120999	2020-09-10	2020-09-15	Standard Class	LC-16930	147.17	4	16.5564
CA-2019-101343	2019-07-17	2019-07-22	Standard Class	RA-19885	77.88	2	3.8940
CA-2020-139619	2020-09-19	2020-09-23	Standard Class	ES-14080	95.62	2	9.5616
CA-2019-118255	2019-03-11	2019-03-13	First Class	ON-18715	45.98	2	19.7714
CA-2019-169194	2019-06-20	2019-06-25	Standard Class	LH-16900	45.00	3	4.9500
CA-2019-105816	2019-12-11	2019-12-17	Standard Class	JM-15265	15.26	7	6.2566
CA-2019-111682	2019-06-17	2019-06-18	First Class	TB-21055	208.56	6	52.1400
CA-2019-119823	2019-06-04	2019-06-06	First Class	KD-16270	75.88	2	35.6636
CA-2019-106075	2019-09-18	2019-09-23	Standard Class	HM-14980	4.62	1	1.7310
CA-2020-114440	2020-09-14	2020-09-17	Second Class	TB-21520	19.05	3	8.7630
US-2020-118038	2020-12-09	2020-12-11	First Class	KB-16600	1.25	3	-1.9344
CA-2019-127208	2019-06-12	2019-06-15	First Class	SC-20770	208.16	1	56.2032
US-2020-119662	2020-11-13	2020-11-16	First Class	CS-12400	230.38	3	-48.9549
CA-2020-140088	2020-05-28	2020-05-30	Second Class	PO-18865	301.96	2	33.2156
CA-2020-155558	2020-10-26	2020-11-02	Standard Class	PG-18895	19.99	1	6.7966
CA-2019-159695	2019-04-05	2019-04-10	Second Class	GM-14455	158.37	7	13.8572
CA-2019-109806	2019-09-17	2019-09-22	Standard Class	JS-15685	20.10	3	6.6330
US-2020-109484	2020-11-06	2020-11-12	Standard Class	RB-19705	5.68	1	-3.7880
CA-2020-161018	2020-11-09	2020-11-11	Second Class	PN-18775	96.53	7	40.5426
CA-2020-157833	2020-06-17	2020-06-20	First Class	KD-16345	51.31	3	17.9592
CA-2019-149223	2019-09-06	2019-09-11	Standard Class	ER-13855	77.88	6	22.5852
CA-2019-158568	2019-08-29	2019-09-02	Standard Class	RB-19465	64.62	7	22.6184
CA-2019-129903	2019-12-01	2019-12-04	Second Class	GZ-14470	23.92	4	11.7208
CA-2020-119004	2020-11-23	2020-11-28	Standard Class	JM-15250	74.11	8	17.6016
CA-2020-146780	2020-12-25	2020-12-30	Standard Class	CV-12805	41.96	2	10.9096
CA-2019-128867	2019-11-03	2019-11-10	Standard Class	CL-12565	75.96	2	22.7880
CA-2019-103730	2019-06-12	2019-06-15	First Class	SC-20725	47.04	3	18.3456
US-2020-107272	2020-11-05	2020-11-12	Standard Class	TS-21610	2.39	2	-1.8308
US-2019-125969	2019-11-06	2019-11-10	Second Class	LS-16975	81.42	2	-9.1602
US-2020-164147	2020-02-02	2020-02-05	First Class	DW-13585	59.97	5	-11.9940
CA-2019-145583	2019-10-13	2019-10-19	Standard Class	LC-16885	20.04	3	9.6192
CA-2019-110366	2019-09-05	2019-09-07	Second Class	JD-15895	82.80	2	10.3500
CA-2020-106180	2020-09-18	2020-09-23	Standard Class	SH-19975	8.82	3	2.3814
CA-2020-155376	2020-12-22	2020-12-27	Standard Class	SG-20080	839.43	3	218.2518
CA-2019-114489	2019-12-05	2019-12-09	Standard Class	JE-16165	384.45	11	103.8015
CA-2019-158834	2019-03-13	2019-03-16	First Class	TW-21025	157.92	5	17.7660
CA-2019-114104	2019-11-20	2019-11-24	Standard Class	NP-18670	14.62	2	6.8714
CA-2019-162733	2019-05-11	2019-05-12	First Class	TT-21070	5.98	1	2.6910
CA-2019-154508	2019-11-16	2019-11-20	Standard Class	RD-19900	28.40	5	13.3480
CA-2019-113817	2019-11-07	2019-11-11	Standard Class	MJ-17740	27.68	2	9.6880
US-2020-152366	2020-04-21	2020-04-25	Second Class	SJ-20500	97.26	4	-243.1600
CA-2019-105018	2019-11-28	2019-12-02	Standard Class	SK-19990	7.16	2	3.4368
CA-2019-157000	2019-07-16	2019-07-22	Standard Class	AM-10360	37.22	3	3.7224
CA-2020-107720	2020-11-06	2020-11-13	Standard Class	VM-21685	46.26	3	12.0276
US-2020-124303	2020-07-06	2020-07-13	Standard Class	FH-14365	2.95	2	-2.2586
CA-2020-105074	2020-06-24	2020-06-29	Standard Class	MB-17305	21.74	3	6.7950
US-2020-116701	2020-12-17	2020-12-21	Second Class	LC-17140	66.28	2	-178.9668
CA-2020-126382	2020-06-03	2020-06-07	Standard Class	HK-14890	35.17	7	9.6712
CA-2020-108329	2020-12-09	2020-12-14	Standard Class	LE-16810	444.77	4	44.4768
CA-2020-135860	2020-12-01	2020-12-07	Standard Class	JH-15985	83.92	4	5.8744
CA-2019-130162	2019-10-28	2019-11-01	Standard Class	JH-15910	93.06	6	26.0568
US-2020-100930	2020-04-07	2020-04-12	Standard Class	CS-12400	233.86	2	-102.0480
CA-2020-160514	2020-11-12	2020-11-16	Standard Class	DB-13120	10.56	2	4.7520
CA-2019-157749	2019-06-04	2019-06-09	Second Class	KL-16645	25.92	5	9.3960
CA-2019-154739	2019-12-10	2019-12-15	Second Class	LH-17155	321.57	2	28.1372
CA-2019-145625	2019-09-11	2019-09-17	Standard Class	KC-16540	7.61	1	3.5767
CA-2019-146941	2019-12-10	2019-12-13	First Class	DL-13315	80.58	6	22.5624
CA-2020-163139	2020-12-01	2020-12-03	Second Class	CC-12670	20.37	3	6.9258
US-2020-155299	2020-06-08	2020-06-12	Standard Class	Dl-13600	1.62	2	-4.4660
CA-2019-125318	2019-06-06	2019-06-13	Standard Class	RC-19825	328.22	4	28.7196
CA-2020-136826	2020-06-16	2020-06-20	Standard Class	CB-12535	14.02	3	4.7304
CA-2019-111010	2019-01-22	2019-01-28	Standard Class	PG-18895	7.56	6	0.3024
US-2020-145366	2020-12-09	2020-12-13	Standard Class	CA-12310	37.21	1	-7.4416
CA-2020-163979	2020-12-28	2019-01-02	Second Class	KH-16690	725.84	4	210.4936
CA-2020-118136	2020-09-16	2020-09-17	First Class	BB-10990	8.82	2	4.0572
CA-2020-132976	2020-10-13	2020-10-17	Standard Class	AG-10495	11.65	2	4.0768
CA-2019-112697	2019-12-18	2019-12-20	Second Class	AH-10195	254.06	7	-169.3720
CA-2019-110772	2019-11-20	2019-11-24	Second Class	NZ-18565	19.10	7	6.6836
CA-2019-142545	2019-10-28	2019-11-03	Standard Class	JD-15895	32.40	5	15.5520
US-2020-152380	2020-11-19	2020-11-23	Standard Class	JH-15910	219.08	3	-131.4450
CA-2020-126774	2020-04-15	2020-04-17	First Class	SH-20395	4.89	1	2.0049
CA-2019-142902	2019-09-12	2019-09-14	Second Class	BP-11185	15.14	4	3.5948
CA-2019-162138	2019-04-23	2019-04-27	Standard Class	GK-14620	251.52	6	81.7440
CA-2020-153339	2020-11-03	2020-11-05	Second Class	DJ-13510	15.99	1	0.9995
US-2019-141544	2019-08-30	2019-09-01	First Class	PO-18850	290.90	3	-67.8762
US-2019-150147	2019-04-25	2019-04-29	Second Class	JL-15850	82.80	2	-20.7000
CA-2020-169901	2020-06-15	2020-06-19	Standard Class	CC-12550	47.98	3	4.7976
CA-2020-134306	2020-07-08	2020-07-12	Standard Class	TD-20995	7.56	3	3.0996
CA-2019-129714	2019-09-01	2019-09-03	First Class	AB-10060	6.79	1	2.3086
CA-2019-138520	2019-04-08	2019-04-13	Standard Class	JL-15505	388.70	6	-4.8588
CA-2019-130001	2019-04-23	2019-04-28	Standard Class	HK-14890	36.24	5	11.3250
CA-2020-155698	2020-03-08	2020-03-11	First Class	VB-21745	647.84	8	168.4384
CA-2020-144904	2020-09-25	2020-10-01	Standard Class	KW-16435	20.70	2	9.9360
CA-2019-155516	2019-10-21	2019-10-21	Same Day	MK-17905	23.20	4	10.4400
CA-2020-104745	2020-05-29	2020-06-04	Standard Class	GT-14755	25.92	5	9.3960
US-2019-134656	2019-09-28	2019-10-01	First Class	MM-18280	99.14	4	30.9800
US-2020-134481	2020-08-27	2020-09-01	Standard Class	AR-10405	1488.42	7	-297.6848
CA-2019-134775	2019-10-28	2019-10-29	First Class	AS-10285	50.96	7	25.4800
CA-2020-101798	2020-12-11	2020-12-15	Standard Class	MV-18190	23.36	4	7.8840
CA-2020-102946	2020-06-30	2020-07-05	Standard Class	VP-21730	75.79	3	25.5798
CA-2020-165603	2020-10-17	2020-10-19	Second Class	SS-20140	49.96	2	9.4924
CA-2019-108987	2019-09-08	2019-09-10	Second Class	AG-10675	35.95	3	3.5952
CA-2020-117933	2020-12-24	2020-12-29	Standard Class	RF-19840	35.91	3	9.6957
CA-2020-117457	2020-12-08	2020-12-12	Standard Class	KH-16510	179.95	5	37.7895
CA-2020-142636	2020-11-03	2020-11-07	Standard Class	KC-16675	139.86	7	65.7342
CA-2020-122105	2020-06-24	2020-06-28	Standard Class	CJ-12010	95.92	8	25.8984
CA-2019-148796	2019-04-14	2019-04-18	Standard Class	PB-19150	383.80	5	38.3800
CA-2020-154816	2020-11-06	2020-11-10	Standard Class	VB-21745	5.78	1	2.8322
CA-2020-110478	2020-03-04	2020-03-09	Standard Class	SP-20860	9.32	4	2.7028
CA-2020-125388	2020-10-19	2020-10-23	Standard Class	MP-17965	56.56	4	14.7056
CA-2020-155705	2020-08-21	2020-08-23	Second Class	NF-18385	866.40	4	225.2640
CA-2020-149160	2020-11-23	2020-11-26	Second Class	JM-15265	28.40	2	11.0760
CA-2020-152275	2020-10-01	2020-10-08	Standard Class	KH-16630	6.67	6	0.5004
US-2019-123750	2019-04-15	2019-04-21	Standard Class	RB-19795	189.59	2	-145.3508
CA-2019-127369	2019-06-06	2019-06-07	First Class	DB-13060	714.30	5	207.1470
CA-2019-147375	2019-06-12	2019-06-14	Second Class	PO-19180	1007.98	3	43.1991
CA-2020-130043	2020-09-15	2020-09-19	Standard Class	BB-11545	31.87	8	11.5536
CA-2020-157252	2020-01-20	2020-01-23	Second Class	CV-12805	207.85	3	2.3094
CA-2019-115756	2019-09-05	2019-09-07	Second Class	PK-19075	12.22	1	3.6660
CA-2020-154214	2020-03-20	2020-03-25	Second Class	TB-21595	2.91	1	1.3677
CA-2019-166674	2019-04-01	2019-04-03	Second Class	RB-19360	59.52	3	15.4752
CA-2020-147277	2020-10-20	2020-10-24	Standard Class	EB-13705	284.36	2	-75.8304
CA-2019-100153	2019-12-13	2019-12-17	Standard Class	KH-16630	63.88	4	24.9132
US-2019-157945	2019-09-26	2019-10-01	Standard Class	NF-18385	747.56	3	-96.1146
CA-2019-109869	2019-04-22	2019-04-29	Standard Class	TN-21040	23.56	5	7.0680
CA-2020-154907	2020-03-31	2020-04-04	Standard Class	DS-13180	205.33	2	-36.2352
US-2019-100419	2019-12-16	2019-12-20	Second Class	CC-12670	4.79	3	-7.9002
CA-2019-103891	2019-07-12	2019-07-19	Standard Class	KH-16690	95.76	6	7.1820
CA-2019-152632	2019-10-27	2019-11-02	Standard Class	JE-15475	40.20	3	19.2960
CA-2019-100790	2019-06-26	2019-07-02	Standard Class	JG-15805	14.70	5	6.6150
CA-2020-140963	2020-06-10	2020-06-13	First Class	MT-18070	29.60	2	14.8000
CA-2019-169166	2019-05-09	2019-05-14	Standard Class	SS-20590	93.98	2	13.1572
US-2019-120929	2019-03-18	2019-03-21	Second Class	RO-19780	189.88	3	-94.9410
CA-2019-126158	2019-07-25	2019-07-31	Standard Class	SC-20095	119.62	8	40.3704
US-2019-105578	2019-05-30	2019-06-04	Standard Class	MY-17380	22.62	2	-15.0800
CA-2020-134978	2020-11-12	2020-11-15	Second Class	EB-13705	15.92	5	5.3730
CA-2020-135307	2020-11-26	2020-11-27	First Class	LS-17245	126.30	3	40.4160
CA-2019-106341	2019-10-20	2019-10-23	First Class	LF-17185	7.15	3	0.7152
CA-2020-163405	2020-12-21	2020-12-25	Standard Class	BN-11515	6.63	3	1.7901
CA-2020-127432	2020-01-22	2020-01-27	Standard Class	AD-10180	2999.95	5	1379.9770
CA-2020-145142	2020-01-23	2020-01-25	First Class	MC-17605	210.98	2	21.0980
US-2019-139486	2019-05-21	2019-05-23	First Class	LH-17155	55.18	3	-12.4146
CA-2020-113558	2020-10-21	2020-10-26	Standard Class	PH-18790	683.95	3	42.7470
US-2020-129441	2020-09-07	2020-09-11	Standard Class	JC-15340	47.94	3	2.3970
CA-2019-168753	2019-05-29	2019-06-01	Second Class	RL-19615	979.95	5	274.3860
CA-2019-126613	2019-07-10	2019-07-16	Standard Class	AA-10375	16.77	2	1.4672
US-2020-122637	2020-09-03	2020-09-08	Second Class	EP-13915	42.62	7	-68.1856
CA-2019-136924	2019-07-14	2019-07-17	First Class	ES-14080	380.86	8	38.0864
CA-2020-162929	2020-11-19	2020-11-22	First Class	AS-10135	41.28	6	13.9320
CA-2019-136406	2019-04-15	2019-04-17	Second Class	BD-11320	1121.57	2	0.0000
CA-2020-112774	2020-09-11	2020-09-12	First Class	RC-19960	34.50	1	6.0382
CA-2020-101945	2020-11-24	2020-11-28	Standard Class	GT-14710	10.82	3	2.5707
CA-2020-100650	2020-06-29	2020-07-03	Second Class	DK-13225	1295.78	2	310.9872
CA-2019-113243	2019-06-10	2019-06-15	Standard Class	OT-18730	20.70	2	9.9360
CA-2020-118731	2020-11-20	2020-11-22	Second Class	LP-17080	42.60	3	16.6140
CA-2020-137099	2020-12-07	2020-12-10	First Class	FP-14320	374.38	3	46.7970
CA-2020-156951	2020-10-01	2020-10-08	Standard Class	EB-13840	91.84	8	45.0016
CA-2020-164826	2020-12-28	2019-01-04	Standard Class	JF-15415	72.45	7	34.7760
CA-2019-127250	2019-11-03	2019-11-07	Standard Class	SF-20200	8.82	3	2.3814
CA-2020-118640	2020-07-20	2020-07-26	Standard Class	CS-11950	69.71	2	8.7140
CA-2020-145233	2020-12-01	2020-12-05	Standard Class	DV-13465	470.38	3	52.9173
US-2019-156986	2019-03-20	2019-03-24	Standard Class	ZC-21910	84.78	2	-20.1362
CA-2019-120200	2019-07-14	2019-07-16	First Class	TP-21130	11.63	2	1.0178
US-2019-100720	2019-07-16	2019-07-21	Standard Class	CK-12205	143.98	3	-28.7964
CA-2019-161816	2019-04-28	2019-05-01	First Class	NB-18655	369.58	3	41.5773
CA-2019-121223	2019-09-11	2019-09-13	Second Class	GD-14590	8.45	2	2.6400
CA-2020-138611	2020-11-14	2020-11-17	Second Class	CK-12595	119.94	10	15.9920
CA-2020-117947	2020-08-18	2020-08-23	Second Class	NG-18355	40.48	2	15.7872
CA-2020-163020	2020-09-15	2020-09-19	Standard Class	MO-17800	35.56	7	12.0904
CA-2020-153787	2020-05-19	2020-05-23	Standard Class	AT-10735	97.16	2	28.1764
CA-2020-133431	2020-12-17	2020-12-21	Standard Class	LC-17140	15.24	5	5.1435
US-2019-135720	2019-12-11	2019-12-13	Second Class	FM-14380	243.38	3	-51.7191
CA-2020-144694	2020-09-24	2020-09-26	Second Class	BD-11605	17.88	3	2.4585
US-2019-123470	2019-08-15	2019-08-21	Standard Class	ME-17725	18.88	3	-13.8468
CA-2019-115917	2019-05-20	2019-05-25	Standard Class	RB-19465	1049.20	5	272.7920
CA-2019-147067	2019-12-18	2019-12-22	Standard Class	JD-16150	18.84	3	6.0288
CA-2020-167913	2020-07-30	2020-08-03	Second Class	JL-15835	330.40	2	85.9040
CA-2020-106103	2020-06-10	2020-06-15	Standard Class	SC-20305	132.52	4	54.3332
US-2020-127719	2020-07-21	2020-07-25	Standard Class	TW-21025	6.48	1	3.1752
CA-2020-126221	2020-12-30	2019-01-05	Standard Class	CC-12430	209.30	2	56.5110
CA-2019-103947	2019-04-01	2019-04-08	Standard Class	BB-10990	31.56	5	9.8625
CA-2019-160745	2019-12-11	2019-12-16	Second Class	AR-10825	14.80	4	6.0680
CA-2019-132661	2019-10-23	2019-10-29	Standard Class	SR-20740	379.40	10	178.3180
CA-2020-140844	2020-06-19	2020-06-23	Standard Class	AR-10405	97.82	2	45.9754
CA-2019-137239	2019-08-22	2019-08-28	Standard Class	CR-12730	113.55	2	8.5164
US-2019-156097	2019-09-19	2019-09-19	Same Day	EH-14125	701.37	2	-50.0980
CA-2019-123666	2019-03-26	2019-03-30	Standard Class	SP-20545	459.95	5	18.3980
CA-2019-143308	2019-11-04	2019-11-04	Same Day	RC-19825	10.74	3	5.2626
CA-2020-132682	2020-06-08	2020-06-10	Second Class	TH-21235	23.76	3	2.0790
US-2020-106663	2020-06-09	2020-06-13	Standard Class	MO-17800	23.98	3	-14.3856
CA-2020-111178	2020-06-15	2020-06-22	Standard Class	TD-20995	19.56	5	1.7115
CA-2020-130351	2020-12-05	2020-12-08	First Class	RB-19570	61.44	3	16.5888
US-2020-119438	2020-03-18	2020-03-23	Standard Class	CD-11980	2.69	3	-7.3920
CA-2019-164511	2019-11-19	2019-11-24	Standard Class	DJ-13630	14.35	3	4.6644
US-2020-168116	2020-11-04	2020-11-04	Same Day	GT-14635	7999.98	4	-3839.9904
CA-2020-161480	2020-12-25	2020-12-29	Standard Class	RA-19285	191.98	2	4.7996
CA-2020-114552	2020-09-02	2020-09-08	Standard Class	Dl-13600	15.07	3	4.1448
CA-2019-163755	2019-11-04	2019-11-08	Second Class	AS-10285	209.88	3	35.6796
CA-2020-146136	2020-09-03	2020-09-07	Standard Class	AP-10915	24.45	4	8.8624
US-2020-100048	2020-05-19	2020-05-24	Standard Class	RS-19765	281.34	6	109.7226
CA-2020-108910	2020-09-24	2020-09-29	Standard Class	KC-16540	103.06	3	24.4758
CA-2019-112942	2019-02-13	2019-02-18	Standard Class	RD-19810	146.82	3	73.4100
CA-2019-142335	2019-12-15	2019-12-19	Standard Class	MP-17965	1652.94	3	231.4116
CA-2019-114713	2019-07-07	2019-07-12	Standard Class	SC-20695	45.58	7	5.1282
CA-2020-144113	2020-09-16	2020-09-20	Standard Class	JF-15355	17.57	2	6.3684
US-2019-150861	2019-12-03	2019-12-06	First Class	EG-13900	182.72	8	84.0512
CA-2020-131954	2020-01-21	2020-01-25	Standard Class	DS-13030	242.94	3	9.7176
US-2019-146710	2019-08-27	2019-09-01	Standard Class	SS-20875	51.52	5	-10.9480
CA-2019-150889	2019-03-20	2019-03-22	Second Class	PB-19105	11.99	1	0.8994
CA-2020-126074	2020-10-02	2020-10-06	Standard Class	RF-19735	58.05	3	26.7030
CA-2019-110499	2019-04-07	2019-04-09	First Class	YC-21895	1199.98	3	374.9925
CA-2019-140928	2019-09-18	2019-09-22	Standard Class	NB-18655	383.44	4	-167.3184
CA-2020-117240	2020-07-23	2020-07-28	Standard Class	CP-12340	13.13	3	4.2666
CA-2020-133333	2020-09-18	2020-09-22	Standard Class	BF-11020	22.72	4	10.2240
CA-2020-126046	2020-11-03	2020-11-07	Standard Class	JC-16105	12.39	3	5.6994
CA-2019-157245	2019-05-19	2019-05-24	Standard Class	LE-16810	641.96	2	179.7488
CA-2020-104220	2020-01-30	2020-02-05	Standard Class	BV-11245	18.28	2	9.1400
CA-2020-129567	2020-03-17	2020-03-21	Second Class	CL-12565	17.46	2	5.8914
CA-2019-105256	2019-05-20	2019-05-20	Same Day	JK-15730	1363.96	5	85.2475
CA-2020-151428	2020-09-21	2020-09-26	Standard Class	RH-19495	20.16	7	9.8784
CA-2020-105809	2020-02-20	2020-02-23	First Class	HW-14935	22.23	1	7.3359
CA-2019-136133	2019-08-18	2019-08-23	Second Class	HW-14935	355.32	9	99.4896
CA-2019-115504	2019-03-12	2019-03-17	Standard Class	MC-18130	12.96	2	6.2208
CA-2020-135783	2020-04-22	2020-04-24	First Class	GM-14440	18.28	2	6.2152
CA-2020-143686	2020-05-14	2020-05-14	Same Day	PJ-19015	18.28	2	6.2152
CA-2019-149370	2019-09-15	2019-09-19	Standard Class	DB-13210	5.34	1	1.8704
CA-2020-101434	2020-06-20	2020-06-27	Standard Class	TR-21325	239.97	3	71.9910
CA-2020-126956	2020-08-21	2020-08-28	Standard Class	GT-14710	35.00	7	16.8000
CA-2020-129462	2020-06-16	2020-06-21	Second Class	JE-15745	301.96	2	90.5880
CA-2019-165316	2019-07-23	2019-07-27	Standard Class	JB-15400	35.22	2	2.6412
US-2020-156083	2020-11-04	2020-11-11	Standard Class	JL-15175	9.66	2	3.2616
US-2019-137547	2019-03-07	2019-03-12	Standard Class	EB-13705	21.07	3	1.5804
CA-2019-161669	2019-11-07	2019-11-09	First Class	EM-14095	37.44	4	11.7000
CA-2020-107503	2020-01-01	2020-01-06	Standard Class	GA-14725	48.90	4	8.5568
CA-2019-152534	2019-06-20	2019-06-25	Second Class	DP-13105	5.16	2	1.3416
CA-2019-113747	2019-05-28	2019-06-04	Standard Class	VD-21670	185.88	6	50.1876
CA-2019-123274	2019-02-19	2019-02-24	Standard Class	GT-14710	44.46	2	14.6718
CA-2020-161984	2020-04-10	2020-04-15	Standard Class	SJ-20125	7.61	1	3.5767
CA-2019-134474	2019-01-05	2019-01-07	Second Class	AJ-10795	191.47	6	40.6878
CA-2019-134362	2019-09-29	2019-10-02	First Class	LS-16945	15.94	4	5.1792
CA-2019-158099	2019-09-03	2019-09-05	First Class	PK-18910	1141.47	5	-760.9800
CA-2020-114636	2020-08-25	2020-08-29	Standard Class	GA-14725	192.16	5	67.2560
CA-2019-116736	2019-01-17	2019-01-21	Standard Class	CC-12430	322.59	3	64.5180
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (productid, categoryid, subcategoryid, productname) FROM stdin;
FUR-BO-10001337	2	11	O'Sullivan Living Dimensions 2-Shelf Bookcases
FUR-BO-10001619	2	11	O'Sullivan Cherrywood Estates Traditional Bookcase
FUR-BO-10001798	2	11	Bush Somerset Collection Bookcase
FUR-BO-10001972	2	11	O'Sullivan 4-Shelf Bookcase in Odessa Pine
FUR-BO-10002268	2	11	Sauder Barrister Bookcases
FUR-BO-10002545	2	11	Atlantic Metals Mobile 3-Shelf Bookcases, Custom Colors
FUR-BO-10002824	2	11	Bush Mission Pointe Library
FUR-BO-10004015	2	11	Bush Andora Bookcase, Maple/Graphite Gray Finish
FUR-BO-10004709	2	11	Bush Westfield Collection Bookcases, Medium Cherry Finish
FUR-BO-10004834	2	11	Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish
FUR-CH-10000015	2	4	Hon Multipurpose Stacking Arm Chairs
FUR-CH-10000454	2	4	Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back
FUR-CH-10000665	2	4	Global Airflow Leather Mesh Back Chair, Black
FUR-CH-10000785	2	4	Global Ergonomic Managers Chair
FUR-CH-10000863	2	4	Novimex Swivel Fabric Task Chair
FUR-CH-10001146	2	4	Global Task Chair, Black
FUR-CH-10001215	2	4	Global Troy Executive Leather Low-Back Tilter
FUR-CH-10001891	2	4	Global Deluxe Office Fabric Chairs
FUR-CH-10002024	2	4	HON 5400 Series Task Chairs for Big and Tall
FUR-CH-10002331	2	4	Hon 4700 Series Mobuis Mid-Back Task Chairs with Adjustable Arms
FUR-CH-10002372	2	4	Office Star - Ergonomically Designed Knee Chair
FUR-CH-10002602	2	4	DMI Arturo Collection Mission-style Design Wood Chair
FUR-CH-10002774	2	4	Global Deluxe Stacking Chair, Gray
FUR-CH-10002965	2	4	Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black
FUR-CH-10003312	2	4	Hon 2090 ?Pillow Soft? Series Mid Back Swivel/Tilt Chairs
FUR-CH-10003379	2	4	Global Commerce Series High-Back Swivel/Tilt Chairs
FUR-CH-10003396	2	4	Global Deluxe Steno Chair
FUR-CH-10003746	2	4	Hon 4070 Series Pagoda Round Back Stacking Chairs
FUR-CH-10003956	2	4	Novimex High-Tech Fabric Mesh Task Chair
FUR-CH-10003968	2	4	Novimex Turbo Task Chair
FUR-CH-10004086	2	4	Hon 4070 Series Pagoda Armless Upholstered Stacking Chairs
FUR-CH-10004886	2	4	Bevis Steel Folding Chairs
FUR-CH-10004997	2	4	Hon Every-Day Series Multi-Task Chairs
FUR-FU-10000010	2	6	DAX Value U-Channel Document Frames, Easel Back
FUR-FU-10000023	2	6	Eldon Wave Desk Accessories
FUR-FU-10000073	2	6	Deflect-O Glasstique Clear Desk Accessories
FUR-FU-10000206	2	6	GE General Purpose, Extra Long Life, Showcase & Floodlight Incandescent Bulbs
FUR-FU-10000221	2	6	Master Caster Door Stop, Brown
FUR-FU-10000246	2	6	Aluminum Document Frame
FUR-FU-10000260	2	6	6" Cubicle Wall Clock, Black
FUR-FU-10000448	2	6	Tenex Chairmats For Use With Carpeted Floors
FUR-FU-10000521	2	6	Seth Thomas 14" Putty-Colored Wall Clock
FUR-FU-10000576	2	6	Luxo Professional Fluorescent Magnifier Lamp with Clamp-Mount Base
FUR-FU-10000629	2	6	9-3/4 Diameter Round Wall Clock
FUR-FU-10000732	2	6	Eldon 200 Class Desk Accessories
FUR-FU-10000794	2	6	Eldon Stackable Tray, Side-Load, Legal, Smoke
FUR-FU-10001290	2	6	Executive Impressions Supervisor Wall Clock
FUR-FU-10001475	2	6	Contract Clock, 14", Brown
FUR-FU-10001706	2	6	Longer-Life Soft White Bulbs
FUR-FU-10001756	2	6	Eldon Expressions Desk Accessory, Wood Photo Frame, Mahogany
FUR-FU-10001861	2	6	Floodlight Indoor Halogen Bulbs, 1 Bulb per Pack, 60 Watts
FUR-FU-10001918	2	6	C-Line Cubicle Keepers Polyproplyene Holder With Velcro Backings
FUR-FU-10001934	2	6	Magnifier Swing Arm Lamp
FUR-FU-10001935	2	6	3M Hangers With Command Adhesive
FUR-FU-10001967	2	6	Telescoping Adjustable Floor Lamp
FUR-FU-10002157	2	6	Artistic Insta-Plaque
FUR-FU-10002253	2	6	Howard Miller 13" Diameter Pewter Finish Round Wall Clock
FUR-FU-10002505	2	6	Eldon 100 Class Desk Accessories
FUR-FU-10002597	2	6	C-Line Magnetic Cubicle Keepers, Clear Polypropylene
FUR-FU-10002671	2	6	Electrix 20W Halogen Replacement Bulb for Zoom-In Desk Lamp
FUR-FU-10002759	2	6	12-1/2 Diameter Round Wall Clock
FUR-FU-10002960	2	6	Eldon 200 Class Desk Accessories, Burgundy
FUR-FU-10003039	2	6	Howard Miller 11-1/2" Diameter Grantwood Wall Clock
FUR-FU-10003347	2	6	Coloredge Poster Frame
FUR-FU-10003394	2	6	Tenex "The Solids" Textured Chair Mats
FUR-FU-10003553	2	6	Howard Miller 13-1/2" Diameter Rosebrook Wall Clock
FUR-FU-10003577	2	6	Nu-Dell Leatherette Frames
FUR-FU-10003664	2	6	Electrix Architect's Clamp-On Swing Arm Lamp, Black
FUR-FU-10003773	2	6	Eldon Cleatmat Plus Chair Mats for High Pile Carpets
FUR-FU-10003849	2	6	DAX Metal Frame, Desktop, Stepped-Edge
FUR-FU-10003878	2	6	Linden 10" Round Wall Clock, Black
FUR-FU-10004017	2	6	Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39" x 49"
FUR-FU-10004090	2	6	Executive Impressions 14" Contract Wall Clock
FUR-FU-10004351	2	6	Staple-based wall hangings
FUR-FU-10004712	2	6	Westinghouse Mesh Shade Clip-On Gooseneck Lamp, Black
FUR-FU-10004848	2	6	Howard Miller 13-3/4" Diameter Brushed Chrome Round Wall Clock
FUR-FU-10004864	2	6	Howard Miller 14-1/2" Diameter Chrome Round Wall Clock
FUR-TA-10000198	2	8	Chromcraft Bull-Nose Wood Oval Conference Tables & Bases
FUR-TA-10000688	2	8	Chromcraft Bull-Nose Wood Round Conference Table Top, Wood Base
FUR-TA-10001095	2	8	Chromcraft Round Conference Tables
FUR-TA-10001539	2	8	Chromcraft Rectangular Conference Tables
FUR-TA-10001705	2	8	Bush Advantage Collection Round Conference Table
FUR-TA-10001857	2	8	Balt Solid Wood Rectangular Table
FUR-TA-10001889	2	8	Bush Advantage Collection Racetrack Conference Table
FUR-TA-10002041	2	8	Bevis Round Conference Table Top, X-Base
FUR-TA-10002228	2	8	Bevis Traditional Conference Table Top, Plinth Base
FUR-TA-10002533	2	8	BPI Conference Tables
FUR-TA-10002607	2	8	KI Conference Tables
FUR-TA-10003473	2	8	Bretford Rectangular Conference Table Tops
FUR-TA-10004256	2	8	Bretford ?Just In Time? Height-Adjustable Multi-Task Work Tables
FUR-TA-10004915	2	8	Office Impressions End Table, 20-1/2"H x 24"W x 20"D
OFF-AP-10000326	3	14	Belkin 7 Outlet SurgeMaster Surge Protector with Phone Protection
OFF-AP-10000358	3	14	Fellowes Basic Home/Office Series Surge Protectors
OFF-AP-10000576	3	14	Belkin 7 Outlet SurgeMaster II
OFF-AP-10000804	3	14	Hoover Portapower Portable Vacuum
OFF-AP-10001058	3	14	Sanyo 2.5 Cubic Foot Mid-Size Office Refrigerators
OFF-AP-10001124	3	14	Belkin 8 Outlet SurgeMaster II Gold Surge Protector with Phone Protection
OFF-AP-10001154	3	14	Bionaire Personal Warm Mist Humidifier/Vaporizer
OFF-AP-10001492	3	14	Acco Six-Outlet Power Strip, 4' Cord Length
OFF-AP-10001563	3	14	Belkin Premiere Surge Master II 8-outlet surge protector
OFF-AP-10002118	3	14	1.7 Cubic Foot Compact "Cube" Office Refrigerators
OFF-AP-10002203	3	14	Eureka Disposable Bags for Sanitaire Vibra Groomer I Upright Vac
OFF-AP-10002350	3	14	Belkin F9H710-06 7 Outlet SurgeMaster Surge Protector
OFF-AP-10002439	3	14	Tripp Lite Isotel 8 Ultra 8 Outlet Metal Surge
OFF-AP-10002457	3	14	Eureka The Boss Plus 12-Amp Hard Box Upright Vacuum, Red
OFF-AP-10002578	3	14	Fellowes Premier Superior Surge Suppressor, 10-Outlet, With Phone and Remote
OFF-AP-10002684	3	14	Acco 7-Outlet Masterpiece Power Center, Wihtout Fax/Phone Line Protection
OFF-AP-10003217	3	14	Eureka Sanitaire  Commercial Upright
OFF-AP-10003266	3	14	Holmes Replacement Filter for HEPA Air Cleaner, Large Room
OFF-AP-10003287	3	14	Tripp Lite TLP810NET Broadband Surge for Modem/Fax
OFF-AP-10003884	3	14	Fellowes Smart Surge Ten-Outlet Protector, Platinum
OFF-AP-10004249	3	14	Staple holder
OFF-AP-10004532	3	14	Kensington 6 Outlet Guardian Standard Surge Protector
OFF-AR-10000246	3	9	Newell 318
OFF-AR-10000369	3	9	Design Ebony Sketching Pencil
OFF-AR-10000380	3	9	Hunt PowerHouse Electric Pencil Sharpener, Blue
OFF-AR-10000390	3	9	Newell Chalk Holder
OFF-AR-10000588	3	9	Newell 345
OFF-AR-10000940	3	9	Newell 343
OFF-AR-10001149	3	9	Sanford Colorific Colored Pencils, 12/Box
OFF-AR-10001246	3	9	Newell 317
OFF-AR-10001374	3	9	BIC Brite Liner Highlighters, Chisel Tip
OFF-AR-10001427	3	9	Newell 330
OFF-AR-10001573	3	9	American Pencil
OFF-AR-10001868	3	9	Prang Dustless Chalk Sticks
OFF-AR-10001953	3	9	Boston 1645 Deluxe Heavier-Duty Electric Pencil Sharpener
OFF-AR-10001954	3	9	Newell 331
OFF-AR-10002053	3	9	Premium Writing Pencils, Soft, #2 by Central Association for the Blind
OFF-AR-10002335	3	9	DIXON Oriole Pencils
OFF-AR-10002399	3	9	Dixon Prang Watercolor Pencils, 10-Color Set with Brush
OFF-AR-10002804	3	9	Faber Castell Col-Erase Pencils
OFF-AR-10002956	3	9	Boston 16801 Nautilus Battery Pencil Sharpener
OFF-AR-10003045	3	9	Prang Colored Pencils
OFF-AR-10003156	3	9	50 Colored Long Pencils
OFF-AR-10003373	3	9	Boston School Pro Electric Pencil Sharpener, 1670
OFF-AR-10003394	3	9	Newell 332
OFF-AR-10003478	3	9	Avery Hi-Liter EverBold Pen Style Fluorescent Highlighters, 4/Pack
OFF-AR-10003602	3	9	Quartet Omega Colored Chalk, 12/Pack
OFF-AR-10003732	3	9	Newell 333
OFF-AR-10003811	3	9	Newell 327
OFF-AR-10003958	3	9	Newell 337
OFF-AR-10004027	3	9	Binney & Smith inkTank Erasable Desk Highlighter, Chisel Tip, Yellow, 12/Box
OFF-AR-10004344	3	9	Bulldog Vacuum Base Pencil Sharpener
OFF-AR-10004648	3	9	Boston 19500 Mighty Mite Electric Pencil Sharpener
OFF-AR-10004685	3	9	Binney & Smith Crayola Metallic Colored Pencils, 8-Color Set
OFF-AR-10004930	3	9	Turquoise Lead Holder with Pocket Clip
OFF-AR-10004974	3	9	Newell 342
OFF-BI-10000014	3	18	Heavy-Duty E-Z-D Binders
OFF-BI-10000050	3	18	Angle-D Binders with Locking Rings, Label Holders
OFF-BI-10000069	3	18	GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb
OFF-BI-10000138	3	18	Acco Translucent Poly Ring Binders
OFF-BI-10000301	3	18	GBC Instant Report Kit
OFF-BI-10000315	3	18	Poly Designer Cover & Back
OFF-BI-10000343	3	18	Pressboard Covers with Storage Hooks, 9 1/2" x 11", Light Blue
OFF-BI-10000404	3	18	Avery Printable Repositionable Plastic Tabs
OFF-BI-10000545	3	18	GBC Ibimaster 500 Manual ProClick Binding System
OFF-BI-10000546	3	18	Avery Durable Binders
OFF-BI-10000605	3	18	Acco Pressboard Covers with Storage Hooks, 9 1/2" x 11", Executive Red
OFF-BI-10000778	3	18	GBC VeloBinder Electric Binding Machine
OFF-BI-10000831	3	18	Storex Flexible Poly Binders with Double Pockets
OFF-BI-10000848	3	18	Angle-D Ring Binders
OFF-BI-10001036	3	18	Cardinal EasyOpen D-Ring Binders
OFF-BI-10001107	3	18	GBC White Gloss Covers, Plain Front
OFF-BI-10001153	3	18	Ibico Recycled Grain-Textured Covers
OFF-BI-10001294	3	18	Fellowes Binding Cases
OFF-BI-10001460	3	18	Plastic Binding Combs
OFF-BI-10001524	3	18	GBC Premium Transparent Covers with Diagonal Lined Pattern
OFF-BI-10001543	3	18	GBC VeloBinder Manual Binding System
OFF-BI-10001634	3	18	Wilson Jones Active Use Binders
OFF-BI-10001636	3	18	Ibico Plastic and Wire Spiral Binding Combs
OFF-BI-10001658	3	18	GBC Standard Therm-A-Bind Covers
OFF-BI-10001670	3	18	Vinyl Sectional Post Binders
OFF-BI-10001679	3	18	GBC Instant Index System for Binding Systems
OFF-BI-10001721	3	18	Trimflex Flexible Post Binders
OFF-BI-10001890	3	18	Avery Poly Binder Pockets
OFF-BI-10001922	3	18	Storex Dura Pro Binders
OFF-BI-10001982	3	18	Wilson Jones Custom Binder Spines & Labels
OFF-BI-10001989	3	18	Premium Transparent Presentation Covers by GBC
OFF-BI-10002160	3	18	Acco Hanging Data Binders
OFF-BI-10002194	3	18	Cardinal Hold-It CD Pocket
OFF-BI-10002225	3	18	Square Ring Data Binders, Rigid 75 Pt. Covers, 11" x 14-7/8"
OFF-BI-10002309	3	18	Avery Heavy-Duty EZD  Binder With Locking Rings
OFF-BI-10002412	3	18	Wilson Jones ?Snap? Scratch Pad Binder Tool for Ring Binders
OFF-BI-10002429	3	18	Premier Elliptical Ring Binder, Black
OFF-BI-10002498	3	18	Clear Mylar Reinforcing Strips
OFF-BI-10002557	3	18	Presstex Flexible Ring Binders
OFF-BI-10002609	3	18	Avery Hidden Tab Dividers for Binding Systems
OFF-BI-10002706	3	18	Avery Premier Heavy-Duty Binder with Round Locking Rings
OFF-BI-10002735	3	18	GBC Prestige Therm-A-Bind Covers
OFF-BI-10002764	3	18	Recycled Pressboard Report Cover with Reinforced Top Hinge
OFF-BI-10002824	3	18	Recycled Easel Ring Binders
OFF-BI-10002827	3	18	Avery Durable Poly Binders
OFF-BI-10002949	3	18	Prestige Round Ring Binders
OFF-BI-10003274	3	18	Avery Durable Slant Ring Binders, No Labels
OFF-BI-10003291	3	18	Wilson Jones Leather-Like Binders with DublLock Round Rings
OFF-BI-10003305	3	18	Avery Hanging File Binders
OFF-BI-10003460	3	18	Acco 3-Hole Punch
OFF-BI-10003638	3	18	GBC Durable Plastic Covers
OFF-BI-10003656	3	18	Fellowes PB200 Plastic Comb Binding Machine
OFF-BI-10003910	3	18	DXL Angle-View Binders with Locking Rings by Samsill
OFF-BI-10003981	3	18	Avery Durable Plastic 1" Binders
OFF-BI-10003982	3	18	Wilson Jones Century Plastic Molded Ring Binders
OFF-BI-10004002	3	18	Wilson Jones International Size A4 Ring Binders
OFF-BI-10004182	3	18	Economy Binders
OFF-BI-10004492	3	18	Tuf-Vin Binders
OFF-BI-10004584	3	18	GBC ProClick 150 Presentation Binding System
OFF-BI-10004593	3	18	Ibico Laser Imprintable Binding System Covers
OFF-BI-10004632	3	18	Ibico Hi-Tech Manual Binding System
OFF-BI-10004654	3	18	Avery Binding System Hidden Tab Executive Style Index Sets
OFF-BI-10004728	3	18	Wilson Jones Turn Tabs Binder Tool for Ring Binders
OFF-BI-10004738	3	18	Flexible Leather- Look Classic Collection Ring Binder
OFF-BI-10004781	3	18	GBC Wire Binding Strips
OFF-BI-10004995	3	18	GBC DocuBind P400 Electric Binding System
OFF-EN-10000483	3	12	White Envelopes, White Envelopes with Clear Poly Window
OFF-EN-10001137	3	12	#10 Gummed Flap White Envelopes, 100/Box
OFF-EN-10001141	3	12	Manila Recycled Extra-Heavyweight Clasp Envelopes, 6" x 9"
OFF-EN-10001219	3	12	#10- 4 1/8" x 9 1/2" Security-Tint Envelopes
OFF-EN-10001415	3	12	Staple envelope
OFF-EN-10001990	3	12	Staple envelope
OFF-EN-10002230	3	12	Airmail Envelopes
OFF-EN-10002500	3	12	Globe Weis Peel & Seel First Class Envelopes
OFF-EN-10003296	3	12	Tyvek Side-Opening Peel & Seel Expanding Envelopes
OFF-EN-10004030	3	12	Convenience Packs of Business Envelopes
OFF-EN-10004386	3	12	Recycled Interoffice Envelopes with String and Button Closure, 10 x 13
OFF-EN-10004459	3	12	Security-Tint Envelopes
OFF-FA-10000134	3	13	Advantus Push Pins, Aluminum Head
OFF-FA-10000304	3	13	Advantus Push Pins
OFF-FA-10000585	3	13	OIC Bulk Pack Metal Binder Clips
OFF-FA-10000621	3	13	OIC Colored Binder Clips, Assorted Sizes
OFF-FA-10000624	3	13	OIC Binder Clips
OFF-FA-10002280	3	13	Advantus Plastic Paper Clips
OFF-FA-10002780	3	13	Staples
OFF-FA-10002983	3	13	Advantus SlideClip Paper Clips
OFF-FA-10002988	3	13	Ideal Clamps
OFF-FA-10003112	3	13	Staples
OFF-FA-10003472	3	13	Bagged Rubber Bands
OFF-FA-10004248	3	13	Advantus T-Pin Paper Clips
OFF-LA-10000134	3	3	Avery 511
OFF-LA-10000240	3	3	Self-Adhesive Address Labels for Typewriters by Universal
OFF-LA-10000634	3	3	Avery 509
OFF-LA-10001074	3	3	Round Specialty Laser Printer Labels
OFF-LA-10001158	3	3	Avery Address/Shipping Labels for Typewriters, 4" x 2"
OFF-LA-10001297	3	3	Avery 473
OFF-LA-10001317	3	3	Avery 520
OFF-LA-10002043	3	3	Avery 489
OFF-LA-10002475	3	3	Avery 519
OFF-LA-10002787	3	3	Avery 480
OFF-LA-10003223	3	3	Avery 508
OFF-LA-10003766	3	3	Self-Adhesive Removable Labels
OFF-LA-10003923	3	3	Alphabetical Labels for Top Tab Filing
OFF-LA-10003930	3	3	Dot Matrix Printer Tape Reel Labels, White, 5000/Box
OFF-LA-10004093	3	3	Avery 486
OFF-LA-10004345	3	3	Avery 493
OFF-LA-10004484	3	3	Avery 476
OFF-LA-10004689	3	3	Avery 512
OFF-LA-10004853	3	3	Avery 483
OFF-PA-10000157	3	16	Xerox 191
OFF-PA-10000249	3	16	Easy-staple paper
OFF-PA-10000304	3	16	Xerox 1995
OFF-PA-10000357	3	16	White Dual Perf Computer Printout Paper, 2700 Sheets, 1 Part, Heavyweight, 20 lbs., 14 7/8 x 11
OFF-PA-10000474	3	16	Easy-staple paper
OFF-PA-10000482	3	16	Snap-A-Way Black Print Carbonless Ruled Speed Letter, Triplicate
OFF-PA-10000587	3	16	Array Parchment Paper, Assorted Colors
OFF-PA-10000673	3	16	Post-it ?Important Message? Note Pad, Neon Colors, 50 Sheets/Pad
OFF-PA-10001204	3	16	Xerox 1972
OFF-PA-10001560	3	16	Adams Telephone Message Books, 5 1/4? x 11?
OFF-PA-10001569	3	16	Xerox 232
OFF-PA-10001667	3	16	Great White Multi-Use Recycled Paper (20Lb. and 84 Bright)
OFF-PA-10001736	3	16	Xerox 1880
OFF-PA-10001790	3	16	Xerox 1910
OFF-PA-10001804	3	16	Xerox 195
OFF-PA-10001870	3	16	Xerox 202
OFF-PA-10001934	3	16	Xerox 1993
OFF-PA-10001950	3	16	Southworth 25% Cotton Antique Laid Paper & Envelopes
OFF-PA-10001954	3	16	Xerox 1964
OFF-PA-10001970	3	16	Xerox 1881
OFF-PA-10002005	3	16	Xerox 225
OFF-PA-10002036	3	16	Xerox 1930
OFF-PA-10002105	3	16	Xerox 223
OFF-PA-10002137	3	16	Southworth 100% R�sum� Paper, 24lb.
OFF-PA-10002222	3	16	Xerox Color Copier Paper, 11" x 17", Ream
OFF-PA-10002230	3	16	Xerox 1897
OFF-PA-10002365	3	16	Xerox 1967
OFF-PA-10002377	3	16	Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages
OFF-PA-10002479	3	16	Xerox 4200 Series MultiUse Premium Copy Paper (20Lb. and 84 Bright)
OFF-PA-10002552	3	16	Xerox 1958
OFF-PA-10002615	3	16	Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled
OFF-PA-10002666	3	16	Southworth 25% Cotton Linen-Finish Paper & Envelopes
OFF-PA-10002713	3	16	Adams Phone Message Book, 200 Message Capacity, 8 1/16? x 11?
OFF-PA-10002749	3	16	Wirebound Message Books, 5-1/2 x 4 Forms, 2 or 4 Forms per Page
OFF-PA-10002751	3	16	Xerox 1920
OFF-PA-10002893	3	16	Wirebound Service Call Books, 5 1/2" x 4"
OFF-PA-10002986	3	16	Xerox 1898
OFF-PA-10003039	3	16	Xerox 1960
OFF-PA-10003256	3	16	Avery Personal Creations Heavyweight Cards
OFF-PA-10003349	3	16	Xerox 1957
OFF-PA-10003441	3	16	Xerox 226
OFF-PA-10003651	3	16	Xerox 1968
OFF-PA-10003724	3	16	Wirebound Message Book, 4 per Page
OFF-PA-10003845	3	16	Xerox 1987
OFF-PA-10003892	3	16	Xerox 1943
OFF-PA-10003953	3	16	Xerox 218
OFF-PA-10004040	3	16	Universal Premium White Copier/Laser Paper (20Lb. and 87 Bright)
OFF-PA-10004092	3	16	Tops Green Bar Computer Printout Paper
OFF-PA-10004101	3	16	Xerox 1894
OFF-PA-10004243	3	16	Xerox 1939
OFF-PA-10004327	3	16	Xerox 1911
OFF-PA-10004451	3	16	Xerox 222
OFF-PA-10004470	3	16	Adams Write n' Stick Phone Message Book, 11" X 5 1/4", 200 Messages
OFF-PA-10004530	3	16	Personal Creations Ink Jet Cards and Labels
OFF-PA-10004569	3	16	Wirebound Message Books, Two 4 1/4" x 5" Forms per Page
OFF-PA-10004675	3	16	Telephone Message Books with Fax/Mobile Section, 5 1/2" x 3 3/16"
OFF-PA-10004734	3	16	Southworth Structures Collection
OFF-PA-10004971	3	16	Xerox 196
OFF-ST-10000036	3	10	Recycled Data-Pak for Archival Bound Computer Printouts, 12-1/2 x 12-1/2 x 16
OFF-ST-10000060	3	10	Fellowes Bankers Box Staxonsteel Drawer File/Stacking System
OFF-ST-10000142	3	10	Deluxe Rollaway Locking File with Drawer
OFF-ST-10000585	3	10	Economy Rollaway Files
OFF-ST-10000604	3	10	Home/Office Personal File Carts
OFF-ST-10000615	3	10	SimpliFile Personal File, Black Granite, 15w x 6-15/16d x 11-1/4h
OFF-ST-10000617	3	10	Woodgrain Magazine Files by Perma
OFF-ST-10000642	3	10	Tennsco Lockers, Gray
OFF-ST-10000675	3	10	File Shuttle II and Handi-File, Black
OFF-ST-10000689	3	10	Fellowes Strictly Business Drawer File, Letter/Legal Size
OFF-ST-10000736	3	10	Carina Double Wide Media Storage Towers in Natural & Black
OFF-ST-10000777	3	10	Companion Letter/Legal File, Black
OFF-ST-10000798	3	10	2300 Heavy-Duty Transfer File Systems by Perma
OFF-ST-10000876	3	10	Eldon Simplefile Box Office
OFF-ST-10000918	3	10	Crate-A-Files
OFF-ST-10000934	3	10	Contico 72"H Heavy-Duty Storage System
OFF-ST-10001228	3	10	Fellowes Personal Hanging Folder Files, Navy
OFF-ST-10001325	3	10	Sterilite Officeware Hinged File Box
OFF-ST-10001328	3	10	Personal Filing Tote with Lid, Black/Gray
OFF-ST-10001414	3	10	Decoflex Hanging Personal Folder File
OFF-ST-10001469	3	10	Fellowes Bankers Box Recycled Super Stor/Drawer
OFF-ST-10001522	3	10	Gould Plastics 18-Pocket Panel Bin, 34w x 5-1/4d x 20-1/2h
OFF-ST-10001580	3	10	Super Decoflex Portable Personal File
OFF-ST-10001780	3	10	Tennsco 16-Compartment Lockers with Coat Rack
OFF-ST-10001963	3	10	Tennsco Regal Shelving Units
OFF-ST-10002205	3	10	File Shuttle I and Handi-File
OFF-ST-10002406	3	10	Pizazz Global Quick File
OFF-ST-10002583	3	10	Fellowes Neat Ideas Storage Cubes
OFF-ST-10002756	3	10	Tennsco Stur-D-Stor Boltless Shelving, 5 Shelves, 24" Deep, Sand
OFF-ST-10002790	3	10	Safco Industrial Shelving
OFF-ST-10002974	3	10	Trav-L-File Heavy-Duty Shuttle II, Black
OFF-ST-10003058	3	10	Eldon Mobile Mega Data Cart  Mega Stackable  Add-On Trays
OFF-ST-10003208	3	10	Adjustable Depth Letter/Legal Cart
OFF-ST-10003282	3	10	Advantus 10-Drawer Portable Organizer, Chrome Metal Frame, Smoke Drawers
OFF-ST-10003306	3	10	Letter Size Cart
OFF-ST-10003442	3	10	Eldon Portable Mobile Manager
OFF-ST-10003479	3	10	Eldon Base for stackable storage shelf, platinum
OFF-ST-10003656	3	10	Safco Industrial Wire Shelving
OFF-ST-10004180	3	10	Safco Commercial Shelving
OFF-ST-10004459	3	10	Tennsco Single-Tier Lockers
OFF-ST-10004507	3	10	Advantus Rolling Storage Box
OFF-ST-10004634	3	10	Personal Folder Holder, Ebony
OFF-SU-10000381	3	2	Acme Forged Steel Scissors with Black Enamel Handles
OFF-SU-10000646	3	2	Premier Automatic Letter Opener
OFF-SU-10001218	3	2	Fiskars Softgrip Scissors
OFF-SU-10001225	3	2	Staple remover
OFF-SU-10001574	3	2	Acme Value Line Scissors
OFF-SU-10002503	3	2	Acme Preferred Stainless Steel Scissors
OFF-SU-10003505	3	2	Premier Electric Letter Opener
OFF-SU-10004115	3	2	Acme Stainless Steel Office Snips
OFF-SU-10004231	3	2	Acme Tagit Stainless Steel Antibacterial Scissors
OFF-SU-10004261	3	2	Fiskars 8" Scissors, 2/Pack
OFF-SU-10004498	3	2	Martin-Yale Premier Letter Opener
OFF-SU-10004664	3	2	Acme Softgrip Scissors
TEC-AC-10000158	4	15	Sony 64GB Class 10 Micro SDHC R40 Memory Card
TEC-AC-10000171	4	15	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 25/Pack
TEC-AC-10000290	4	15	Sabrent 4-Port USB 2.0 Hub
TEC-AC-10000991	4	15	Sony Micro Vault Click 8 GB USB 2.0 Flash Drive
TEC-AC-10001101	4	15	Sony 16GB Class 10 Micro SDHC R40 Memory Card
TEC-AC-10001142	4	15	First Data FD10 PIN Pad
TEC-AC-10001267	4	15	Imation�32GB Pocket Pro USB 3.0�Flash Drive�- 32 GB - Black - 1 P ...
TEC-AC-10001606	4	15	Logitech Wireless Performance Mouse MX for PC and Mac
TEC-AC-10001714	4	15	Logitech�MX Performance Wireless Mouse
TEC-AC-10001767	4	15	SanDisk Ultra 64 GB MicroSDHC Class 10 Memory Card
TEC-AC-10001772	4	15	Memorex Mini Travel Drive 16 GB USB 2.0 Flash Drive
TEC-AC-10001838	4	15	Razer Tiamat Over Ear 7.1 Surround Sound PC Gaming Headset
TEC-AC-10001908	4	15	Logitech Wireless Headset h800
TEC-AC-10001998	4	15	Logitech�LS21 Speaker System - PC Multimedia - 2.1-CH - Wired
TEC-AC-10002001	4	15	Logitech Wireless Gaming Headset G930
TEC-AC-10002049	4	15	Logitech G19 Programmable Gaming Keyboard
TEC-AC-10002167	4	15	Imation�8gb Micro Traveldrive Usb 2.0�Flash Drive
TEC-AC-10002399	4	15	SanDisk Cruzer 32 GB USB Flash Drive
TEC-AC-10002402	4	15	Razer Kraken PRO Over Ear PC and Music Headset
TEC-AC-10002857	4	15	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 1/Pack
TEC-AC-10003027	4	15	Imation�8GB Mini TravelDrive USB 2.0�Flash Drive
TEC-AC-10003499	4	15	Memorex Mini Travel Drive 8 GB USB 2.0 Flash Drive
TEC-AC-10003610	4	15	Logitech�Illuminated - Keyboard
TEC-AC-10003614	4	15	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 10/Pack
TEC-AC-10003628	4	15	Logitech 910-002974 M325 Wireless Mouse for Web Scrolling
TEC-AC-10003832	4	15	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive
TEC-AC-10004659	4	15	Imation�Secure+ Hardware Encrypted USB 2.0�Flash Drive; 16GB
TEC-CO-10002095	4	1	Hewlett Packard 610 Color Digital Copier / Printer
TEC-CO-10003236	4	1	Canon Image Class D660 Copier
TEC-CO-10004115	4	1	Sharp AL-1530CS Digital Copier
TEC-MA-10002937	4	5	Canon Color ImageCLASS MF8580Cdw Wireless Laser All-In-One Printer, Copier, Scanner
TEC-MA-10004002	4	5	Zebra GX420t Direct Thermal/Thermal Transfer Printer
TEC-MA-10004125	4	5	Cubify CubeX 3D Printer Triple Head Print
TEC-PH-10000004	4	17	Belkin iPhone and iPad Lightning Cable
TEC-PH-10000011	4	17	PureGear Roll-On Screen Protector
TEC-PH-10000149	4	17	Cisco SPA525G2 IP Phone - Wireless
TEC-PH-10000215	4	17	Plantronics Cordless�Phone Headset�with In-line Volume - M214C
TEC-PH-10000347	4	17	Cush Cases Heavy Duty Rugged Cover Case for Samsung Galaxy S5 - Purple
TEC-PH-10000586	4	17	AT&T SB67148 SynJ
TEC-PH-10000984	4	17	Panasonic KX-TG9471B
TEC-PH-10001254	4	17	Jabra BIZ 2300 Duo QD Duo Corded�Headset
TEC-PH-10001425	4	17	Mophie Juice Pack Helium for iPhone
TEC-PH-10001433	4	17	Cisco Small Business SPA 502G VoIP phone
TEC-PH-10001448	4	17	Anker Astro 15000mAh USB Portable Charger
TEC-PH-10001530	4	17	Cisco Unified IP Phone 7945G VoIP phone
TEC-PH-10001557	4	17	Pyle PMP37LED
TEC-PH-10001580	4	17	Logitech Mobile Speakerphone P710e -�speaker phone
TEC-PH-10001700	4	17	Panasonic KX-TG6844B Expandable Digital Cordless Telephone
TEC-PH-10001918	4	17	Nortel Business Series Terminal T7208 Digital phone
TEC-PH-10001924	4	17	iHome FM Clock Radio with Lightning Dock
TEC-PH-10002085	4	17	Clarity 53712
TEC-PH-10002103	4	17	Jabra SPEAK 410
TEC-PH-10002170	4	17	ClearSounds CSC500 Amplified Spirit Phone Corded phone
TEC-PH-10002262	4	17	LG Electronics Tone+ HBS-730 Bluetooth Headset
TEC-PH-10002293	4	17	Anker 36W 4-Port USB Wall Charger Travel Power Adapter for iPhone 5s 5c 5
TEC-PH-10002365	4	17	Belkin Grip Candy Sheer Case / Cover for iPhone 5 and 5S
TEC-PH-10002447	4	17	AT&T CL83451 4-Handset Telephone
TEC-PH-10002496	4	17	Cisco SPA301
TEC-PH-10002538	4	17	Grandstream GXP1160 VoIP phone
TEC-PH-10002563	4	17	Adtran 1202752G1
TEC-PH-10002844	4	17	Speck Products Candyshell Flip Case
TEC-PH-10002923	4	17	Logitech B530 USB�Headset�-�headset�- Full size, Binaural
TEC-PH-10003012	4	17	Nortel Meridian M3904 Professional Digital phone
TEC-PH-10003273	4	17	AT&T TR1909W
TEC-PH-10003555	4	17	Motorola HK250 Universal Bluetooth Headset
TEC-PH-10003645	4	17	Aastra 57i VoIP phone
TEC-PH-10003800	4	17	i.Sound Portable Power - 8000 mAh
TEC-PH-10003875	4	17	KLD Oscar II Style Snap-on Ultra Thin Side Flip Synthetic Leather Cover Case for HTC One HTC M7
TEC-PH-10003963	4	17	GE 2-Jack Phone Line Splitter
TEC-PH-10003988	4	17	LF Elite 3D Dazzle Designer Hard Case Cover, Lf Stylus Pen and Wiper For Apple Iphone 5c Mini Lite
TEC-PH-10004042	4	17	ClearOne Communications CHAT 70 OC�Speaker Phone
TEC-PH-10004093	4	17	Panasonic Kx-TS550
TEC-PH-10004536	4	17	Avaya 5420 Digital phone
TEC-PH-10004614	4	17	AT&T 841000 Phone
TEC-PH-10004667	4	17	Cisco 8x8 Inc. 6753i IP Business Phone System
TEC-PH-10004977	4	17	GE 30524EE4
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (regionid, regionname) FROM stdin;
1	\N
2	South
3	West
4	East
5	Central
\.


--
-- Data for Name: segments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.segments (segmentid, segmentname) FROM stdin;
1	Home Office
2	\N
3	Consumer
4	Corporate
\.


--
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipments (shipmentid, orderid, productid, shipdate, shipmode, quantity) FROM stdin;
1	CA-2019-152156	FUR-BO-10001798	2019-11-11	Second Class	2
2	CA-2019-152156	FUR-CH-10000454	2019-11-11	Second Class	3
3	CA-2019-138688	OFF-LA-10000240	2019-06-16	Second Class	2
4	CA-2020-114412	OFF-PA-10002365	2020-04-20	Standard Class	3
5	CA-2019-161389	OFF-BI-10003656	2019-12-10	Standard Class	3
6	CA-2019-137330	OFF-AR-10000246	2019-12-13	Standard Class	7
7	CA-2019-137330	OFF-AP-10001492	2019-12-13	Standard Class	7
8	US-2020-156909	FUR-CH-10002774	2020-07-18	Second Class	2
9	CA-2019-121755	OFF-BI-10001634	2019-01-20	Second Class	2
10	CA-2019-121755	TEC-AC-10003027	2019-01-20	Second Class	3
11	CA-2020-107727	OFF-PA-10000249	2020-10-23	Second Class	3
12	CA-2019-117590	TEC-PH-10004977	2019-12-10	First Class	7
13	CA-2019-117590	FUR-FU-10003664	2019-12-10	First Class	5
14	CA-2020-120999	TEC-PH-10004093	2020-09-15	Standard Class	4
15	CA-2019-101343	OFF-ST-10003479	2019-07-22	Standard Class	2
16	CA-2020-139619	OFF-ST-10003282	2020-09-23	Standard Class	2
17	CA-2019-118255	TEC-AC-10000171	2019-03-13	First Class	2
18	CA-2019-118255	OFF-BI-10003291	2019-03-13	First Class	2
19	CA-2019-169194	TEC-AC-10002167	2019-06-25	Standard Class	3
20	CA-2019-169194	TEC-PH-10003988	2019-06-25	Standard Class	2
21	CA-2019-105816	OFF-FA-10000304	2019-12-17	Standard Class	7
22	CA-2019-105816	TEC-PH-10002447	2019-12-17	Standard Class	5
23	CA-2019-111682	OFF-ST-10000604	2019-06-18	First Class	6
24	CA-2019-111682	OFF-PA-10001569	2019-06-18	First Class	5
25	CA-2019-111682	FUR-CH-10003968	2019-06-18	First Class	5
26	CA-2019-111682	OFF-PA-10000587	2019-06-18	First Class	2
27	CA-2019-111682	TEC-AC-10002167	2019-06-18	First Class	2
28	CA-2019-111682	OFF-BI-10001460	2019-06-18	First Class	4
29	CA-2019-111682	OFF-AR-10001868	2019-06-18	First Class	1
30	CA-2019-119823	OFF-PA-10000482	2019-06-06	First Class	2
31	CA-2019-106075	OFF-BI-10004654	2019-09-23	Standard Class	1
32	CA-2020-114440	OFF-PA-10004675	2020-09-17	Second Class	3
33	US-2020-118038	OFF-BI-10004182	2020-12-11	First Class	3
34	US-2020-118038	FUR-FU-10000260	2020-12-11	First Class	3
35	US-2020-118038	OFF-ST-10000615	2020-12-11	First Class	3
36	CA-2019-127208	OFF-AP-10002118	2019-06-15	First Class	1
37	CA-2019-127208	OFF-BI-10002309	2019-06-15	First Class	3
38	US-2020-119662	OFF-ST-10003656	2020-11-16	First Class	3
39	CA-2020-140088	FUR-CH-10000863	2020-05-30	Second Class	2
40	CA-2020-155558	TEC-AC-10001998	2020-11-02	Standard Class	1
41	CA-2020-155558	OFF-LA-10000134	2020-11-02	Standard Class	2
42	CA-2019-159695	OFF-ST-10003442	2019-04-10	Second Class	7
43	CA-2019-109806	OFF-AR-10004930	2019-09-22	Standard Class	3
44	CA-2019-109806	TEC-PH-10004093	2019-09-22	Standard Class	2
45	CA-2019-109806	OFF-PA-10000304	2019-09-22	Standard Class	1
46	US-2020-109484	OFF-BI-10004738	2020-11-12	Standard Class	1
47	CA-2020-161018	FUR-FU-10000629	2020-11-11	Second Class	7
48	CA-2020-157833	OFF-BI-10001721	2020-06-20	First Class	3
49	CA-2019-149223	OFF-AP-10000358	2019-09-11	Standard Class	6
50	CA-2019-158568	OFF-PA-10003256	2019-09-02	Standard Class	7
51	CA-2019-158568	TEC-AC-10001767	2019-09-02	Standard Class	3
52	CA-2019-158568	OFF-BI-10002609	2019-09-02	Standard Class	3
53	CA-2019-129903	OFF-PA-10004040	2019-12-04	Second Class	4
54	CA-2020-119004	TEC-AC-10003499	2020-11-28	Standard Class	8
55	CA-2020-119004	TEC-PH-10002844	2020-11-28	Standard Class	1
56	CA-2020-119004	OFF-AR-10000390	2020-11-28	Standard Class	1
57	CA-2020-146780	FUR-FU-10001934	2020-12-30	Standard Class	2
58	CA-2019-128867	OFF-AR-10000380	2019-11-10	Standard Class	2
59	CA-2019-128867	OFF-BI-10003981	2019-11-10	Standard Class	6
60	CA-2019-103730	FUR-FU-10002157	2019-06-15	First Class	3
61	CA-2019-103730	OFF-BI-10003910	2019-06-15	First Class	4
62	CA-2019-103730	OFF-ST-10000777	2019-06-15	First Class	6
63	CA-2019-103730	OFF-EN-10002500	2019-06-15	First Class	9
64	CA-2019-103730	TEC-PH-10003875	2019-06-15	First Class	7
65	US-2020-107272	OFF-BI-10003274	2020-11-12	Standard Class	2
66	US-2020-107272	OFF-ST-10002974	2020-11-12	Standard Class	7
67	US-2019-125969	FUR-CH-10001146	2019-11-10	Second Class	2
68	US-2019-125969	FUR-FU-10003773	2019-11-10	Second Class	3
69	US-2020-164147	TEC-PH-10002293	2020-02-05	First Class	5
70	US-2020-164147	OFF-PA-10002377	2020-02-05	First Class	2
71	US-2020-164147	OFF-FA-10002780	2020-02-05	First Class	9
72	CA-2019-145583	OFF-PA-10001804	2019-10-19	Standard Class	3
73	CA-2019-145583	OFF-PA-10001736	2019-10-19	Standard Class	1
74	CA-2019-145583	OFF-AR-10001149	2019-10-19	Standard Class	4
75	CA-2019-145583	OFF-FA-10002988	2019-10-19	Standard Class	2
76	CA-2019-145583	OFF-BI-10004781	2019-10-19	Standard Class	3
77	CA-2019-145583	OFF-SU-10001218	2019-10-19	Standard Class	6
78	CA-2019-145583	FUR-FU-10001706	2019-10-19	Standard Class	14
79	CA-2019-110366	FUR-FU-10004848	2019-09-07	Second Class	2
80	CA-2020-106180	OFF-AR-10000940	2020-09-23	Standard Class	3
81	CA-2020-106180	OFF-EN-10004030	2020-09-23	Standard Class	3
82	CA-2020-106180	OFF-PA-10004327	2020-09-23	Standard Class	3
83	CA-2020-155376	OFF-AP-10001058	2020-12-27	Standard Class	3
84	CA-2019-114489	TEC-PH-10000215	2019-12-09	Standard Class	11
85	CA-2019-114489	TEC-PH-10001448	2019-12-09	Standard Class	3
86	CA-2019-114489	FUR-CH-10000454	2019-12-09	Standard Class	8
87	CA-2019-114489	OFF-BI-10002735	2019-12-09	Standard Class	5
88	CA-2019-158834	OFF-AP-10000326	2019-03-16	First Class	5
89	CA-2019-158834	TEC-PH-10001254	2019-03-16	First Class	2
90	CA-2019-114104	OFF-LA-10002475	2019-11-24	Standard Class	2
91	CA-2019-114104	TEC-PH-10004536	2019-11-24	Standard Class	7
92	CA-2019-162733	OFF-PA-10002751	2019-05-12	First Class	1
93	CA-2019-154508	OFF-EN-10001990	2019-11-20	Standard Class	5
94	CA-2019-113817	OFF-BI-10004002	2019-11-11	Standard Class	2
95	US-2020-152366	OFF-AP-10002684	2020-04-25	Second Class	4
96	CA-2019-105018	OFF-BI-10001890	2019-12-02	Standard Class	2
97	CA-2019-157000	OFF-ST-10001328	2019-07-22	Standard Class	3
98	CA-2019-157000	OFF-PA-10001950	2019-07-22	Standard Class	3
99	CA-2020-107720	OFF-ST-10001414	2020-11-13	Standard Class	3
100	US-2020-124303	OFF-BI-10000343	2020-07-13	Standard Class	2
101	US-2020-124303	OFF-PA-10002749	2020-07-13	Standard Class	3
102	CA-2020-105074	OFF-PA-10002666	2020-06-29	Standard Class	3
103	US-2020-116701	OFF-AP-10003217	2020-12-21	Second Class	2
104	CA-2020-126382	FUR-FU-10002960	2020-06-07	Standard Class	7
105	CA-2020-108329	TEC-PH-10001918	2020-12-14	Standard Class	4
106	CA-2020-135860	OFF-ST-10000642	2020-12-07	Standard Class	4
107	CA-2020-135860	TEC-PH-10001700	2020-12-07	Standard Class	2
108	CA-2020-135860	OFF-BI-10003274	2020-12-07	Standard Class	4
109	CA-2020-135860	OFF-FA-10000134	2020-12-07	Standard Class	9
110	CA-2020-135860	OFF-ST-10001522	2020-12-07	Standard Class	1
111	CA-2019-130162	OFF-ST-10001328	2019-11-01	Standard Class	6
112	CA-2019-130162	TEC-PH-10002563	2019-11-01	Standard Class	3
113	US-2020-100930	FUR-TA-10001705	2020-04-12	Standard Class	2
114	US-2020-100930	FUR-TA-10003473	2020-04-12	Standard Class	3
115	US-2020-100930	OFF-BI-10001679	2020-04-12	Standard Class	2
116	US-2020-100930	FUR-FU-10004017	2020-04-12	Standard Class	3
117	US-2020-100930	TEC-AC-10003832	2020-04-12	Standard Class	3
118	CA-2020-160514	OFF-PA-10002479	2020-11-16	Standard Class	2
119	CA-2019-157749	OFF-PA-10003349	2019-06-09	Second Class	5
120	CA-2019-157749	FUR-FU-10000576	2019-06-09	Second Class	5
121	CA-2019-157749	FUR-FU-10004351	2019-06-09	Second Class	3
122	CA-2019-157749	TEC-PH-10000011	2019-06-09	Second Class	2
123	CA-2019-157749	FUR-TA-10002607	2019-06-09	Second Class	5
124	CA-2019-157749	FUR-FU-10002505	2019-06-09	Second Class	3
125	CA-2019-157749	OFF-AR-10004685	2019-06-09	Second Class	2
126	CA-2019-154739	FUR-CH-10002965	2019-12-15	Second Class	2
127	CA-2019-145625	OFF-PA-10004569	2019-09-17	Standard Class	1
128	CA-2019-145625	TEC-AC-10003832	2019-09-17	Standard Class	13
129	CA-2019-146941	OFF-ST-10001228	2019-12-13	First Class	6
130	CA-2019-146941	OFF-EN-10003296	2019-12-13	First Class	4
131	CA-2020-163139	TEC-AC-10000290	2020-12-03	Second Class	3
132	CA-2020-163139	OFF-ST-10002790	2020-12-03	Second Class	3
133	CA-2020-163139	OFF-BI-10003460	2020-12-03	Second Class	5
134	US-2020-155299	OFF-AP-10002203	2020-06-12	Standard Class	2
135	CA-2019-125318	TEC-PH-10001433	2019-06-13	Standard Class	4
136	CA-2020-136826	OFF-AR-10003602	2020-06-20	Standard Class	3
137	CA-2019-111010	OFF-FA-10003472	2019-01-28	Standard Class	6
138	US-2020-145366	OFF-ST-10004180	2020-12-13	Standard Class	1
139	US-2020-145366	OFF-EN-10004386	2020-12-13	Standard Class	3
140	CA-2020-163979	OFF-ST-10003208	2019-01-02	Second Class	4
141	CA-2020-118136	OFF-PA-10002615	2020-09-17	First Class	2
142	CA-2020-118136	OFF-AR-10001427	2020-09-17	First Class	1
143	CA-2020-132976	OFF-PA-10000673	2020-10-17	Standard Class	2
144	CA-2020-132976	OFF-PA-10004470	2020-10-17	Standard Class	4
145	CA-2020-132976	OFF-ST-10000876	2020-10-17	Standard Class	6
146	CA-2020-132976	OFF-LA-10002043	2020-10-17	Standard Class	3
147	CA-2019-112697	OFF-BI-10000778	2019-12-20	Second Class	7
148	CA-2019-112697	OFF-AP-10002684	2019-12-20	Second Class	2
149	CA-2019-112697	OFF-SU-10000646	2019-12-20	Second Class	5
150	CA-2019-110772	OFF-FA-10002983	2019-11-24	Second Class	7
151	CA-2019-110772	OFF-LA-10004689	2019-11-24	Second Class	8
152	CA-2019-110772	TEC-AC-10002001	2019-11-24	Second Class	2
153	CA-2019-110772	FUR-BO-10004709	2019-11-24	Second Class	3
154	CA-2019-142545	OFF-PA-10002105	2019-11-03	Standard Class	5
155	CA-2019-142545	OFF-ST-10002756	2019-11-03	Standard Class	8
156	CA-2019-142545	OFF-PA-10004243	2019-11-03	Standard Class	3
157	CA-2019-142545	FUR-FU-10001861	2019-11-03	Standard Class	4
158	CA-2019-142545	OFF-BI-10002706	2019-11-03	Standard Class	1
159	US-2020-152380	FUR-TA-10002533	2020-11-23	Standard Class	3
160	CA-2020-126774	OFF-AR-10002804	2020-04-17	First Class	1
161	CA-2019-142902	FUR-FU-10001918	2019-09-14	Second Class	4
162	CA-2019-142902	FUR-CH-10004086	2019-09-14	Second Class	2
163	CA-2019-142902	FUR-FU-10001756	2019-09-14	Second Class	1
164	CA-2019-142902	OFF-LA-10000634	2019-09-14	Second Class	3
165	CA-2019-162138	OFF-BI-10004593	2019-04-27	Standard Class	6
166	CA-2019-162138	TEC-AC-10001908	2019-04-27	Standard Class	1
167	CA-2020-153339	FUR-FU-10001967	2020-11-05	Second Class	1
168	US-2019-141544	TEC-PH-10003645	2019-09-01	First Class	3
169	US-2019-141544	OFF-ST-10000675	2019-09-01	First Class	2
170	US-2019-141544	FUR-CH-10003312	2019-09-01	First Class	4
171	US-2019-141544	OFF-LA-10001074	2019-09-01	First Class	10
172	US-2019-141544	OFF-BI-10001524	2019-09-01	First Class	6
173	US-2019-150147	TEC-PH-10004614	2019-04-29	Second Class	2
174	US-2019-150147	OFF-BI-10001153	2019-04-29	Second Class	2
175	US-2019-150147	OFF-BI-10001982	2019-04-29	Second Class	3
176	CA-2020-169901	TEC-PH-10002293	2020-06-19	Standard Class	3
177	CA-2020-134306	OFF-AR-10004027	2020-07-12	Standard Class	3
178	CA-2020-134306	OFF-PA-10000249	2020-07-12	Standard Class	2
179	CA-2020-134306	OFF-AR-10001374	2020-07-12	Standard Class	2
180	CA-2019-129714	TEC-AC-10000290	2019-09-03	First Class	1
181	CA-2019-129714	OFF-PA-10001970	2019-09-03	First Class	2
182	CA-2019-129714	OFF-BI-10002160	2019-09-03	First Class	1
183	CA-2019-129714	OFF-PA-10001970	2019-09-03	First Class	4
184	CA-2019-129714	OFF-BI-10004995	2019-09-03	First Class	4
185	CA-2019-138520	FUR-BO-10002268	2019-04-13	Standard Class	6
186	CA-2019-138520	OFF-EN-10001137	2019-04-13	Standard Class	2
187	CA-2019-138520	OFF-AR-10002399	2019-04-13	Standard Class	4
188	CA-2019-138520	OFF-PA-10002713	2019-04-13	Standard Class	5
189	CA-2019-130001	OFF-PA-10002666	2019-04-28	Standard Class	5
190	CA-2020-155698	OFF-AP-10001124	2020-03-11	First Class	8
191	CA-2020-155698	OFF-LA-10001158	2020-03-11	First Class	2
192	CA-2020-144904	OFF-LA-10001158	2020-10-01	Standard Class	2
193	CA-2020-144904	FUR-CH-10000785	2020-10-01	Standard Class	3
194	CA-2020-144904	OFF-AR-10003732	2020-10-01	Standard Class	2
195	CA-2020-144904	FUR-FU-10000023	2020-10-01	Standard Class	8
196	CA-2019-155516	OFF-BI-10002412	2019-10-21	Same Day	4
197	CA-2019-155516	OFF-SU-10001225	2019-10-21	Same Day	2
198	CA-2019-155516	OFF-ST-10002406	2019-10-21	Same Day	7
199	CA-2019-155516	FUR-BO-10002545	2019-10-21	Same Day	4
200	CA-2020-104745	OFF-PA-10002036	2020-06-04	Standard Class	5
201	CA-2020-104745	OFF-ST-10002205	2020-06-04	Standard Class	3
202	US-2019-134656	OFF-PA-10003039	2019-10-01	First Class	4
203	US-2020-134481	FUR-TA-10004915	2020-09-01	Standard Class	7
204	CA-2019-134775	OFF-PA-10004734	2019-10-29	First Class	7
205	CA-2019-134775	OFF-BI-10002225	2019-10-29	First Class	3
206	CA-2020-101798	OFF-BI-10000050	2020-12-15	Standard Class	4
207	CA-2020-101798	TEC-AC-10001998	2020-12-15	Standard Class	2
208	CA-2020-102946	OFF-BI-10004492	2020-07-05	Standard Class	3
209	CA-2020-165603	OFF-ST-10000798	2020-10-19	Second Class	2
210	CA-2020-165603	OFF-PA-10002552	2020-10-19	Second Class	2
211	CA-2019-108987	OFF-ST-10001580	2019-09-10	Second Class	3
212	CA-2019-108987	FUR-BO-10004834	2019-09-10	Second Class	4
213	CA-2019-108987	OFF-ST-10000934	2019-09-10	Second Class	4
214	CA-2019-108987	TEC-AC-10000158	2019-09-10	Second Class	2
215	CA-2020-117933	OFF-AP-10004249	2020-12-29	Standard Class	3
216	CA-2020-117457	TEC-AC-10000158	2020-12-12	Standard Class	5
217	CA-2020-117457	TEC-CO-10004115	2020-12-12	Standard Class	3
218	CA-2020-117457	OFF-PA-10003724	2020-12-12	Standard Class	5
219	CA-2020-117457	FUR-TA-10002041	2020-12-12	Standard Class	7
220	CA-2020-117457	OFF-PA-10002893	2020-12-12	Standard Class	1
221	CA-2020-117457	OFF-LA-10003766	2020-12-12	Standard Class	9
222	CA-2020-117457	OFF-PA-10001970	2020-12-12	Standard Class	1
223	CA-2020-117457	FUR-BO-10001972	2020-12-12	Standard Class	13
224	CA-2020-117457	FUR-CH-10003956	2020-12-12	Standard Class	2
225	CA-2020-142636	OFF-PA-10000157	2020-11-07	Standard Class	7
226	CA-2020-142636	FUR-CH-10001891	2020-11-07	Standard Class	4
227	CA-2020-122105	OFF-AR-10004344	2020-06-28	Standard Class	8
228	CA-2019-148796	FUR-CH-10004886	2019-04-18	Standard Class	5
229	CA-2020-154816	OFF-PA-10003845	2020-11-10	Standard Class	1
230	CA-2020-110478	OFF-AR-10001573	2020-03-09	Standard Class	4
231	CA-2020-110478	OFF-EN-10000483	2020-03-09	Standard Class	1
232	CA-2020-125388	FUR-FU-10004712	2020-10-23	Standard Class	4
233	CA-2020-125388	OFF-ST-10000918	2020-10-23	Standard Class	3
234	CA-2020-155705	FUR-CH-10000015	2020-08-23	Second Class	4
235	CA-2020-149160	FUR-FU-10003347	2020-11-26	Second Class	2
236	CA-2020-149160	OFF-BI-10001543	2020-11-26	Second Class	8
237	CA-2020-152275	OFF-AR-10000369	2020-10-08	Standard Class	6
238	US-2019-123750	OFF-BI-10004584	2019-04-21	Standard Class	2
239	US-2019-123750	TEC-AC-10004659	2019-04-21	Standard Class	7
240	US-2019-123750	TEC-AC-10004659	2019-04-21	Standard Class	5
241	US-2019-123750	OFF-ST-10000617	2019-04-21	Standard Class	2
242	CA-2019-127369	OFF-ST-10003306	2019-06-07	First Class	5
243	CA-2019-147375	TEC-MA-10002937	2019-06-14	Second Class	3
244	CA-2019-147375	OFF-PA-10001970	2019-06-14	Second Class	7
245	CA-2020-130043	OFF-PA-10002230	2020-09-19	Standard Class	8
246	CA-2020-157252	FUR-CH-10003396	2020-01-23	Second Class	3
247	CA-2019-115756	FUR-FU-10000246	2019-09-07	Second Class	1
248	CA-2019-115756	OFF-ST-10000060	2019-09-07	Second Class	3
249	CA-2019-115756	OFF-ST-10003058	2019-09-07	Second Class	3
250	CA-2019-115756	OFF-PA-10002222	2019-09-07	Second Class	4
251	CA-2019-115756	FUR-CH-10002372	2019-09-07	Second Class	3
252	CA-2019-115756	OFF-LA-10001317	2019-09-07	Second Class	7
253	CA-2020-154214	FUR-FU-10000206	2020-03-25	Second Class	1
254	CA-2019-166674	OFF-AR-10000588	2019-04-03	Second Class	3
255	CA-2019-166674	OFF-ST-10001469	2019-04-03	Second Class	3
256	CA-2019-166674	OFF-AR-10001953	2019-04-03	Second Class	6
257	CA-2019-166674	OFF-AR-10003156	2019-04-03	Second Class	3
258	CA-2019-166674	OFF-AR-10004974	2019-04-03	Second Class	3
259	CA-2019-166674	TEC-PH-10002365	2019-04-03	Second Class	4
260	CA-2020-147277	FUR-TA-10001539	2020-10-24	Standard Class	2
261	CA-2020-147277	OFF-ST-10000142	2020-10-24	Standard Class	2
262	CA-2019-100153	TEC-AC-10001772	2019-12-17	Standard Class	4
263	US-2019-157945	FUR-CH-10002331	2019-10-01	Standard Class	3
264	US-2019-157945	OFF-EN-10001415	2019-10-01	Standard Class	2
265	CA-2019-109869	FUR-FU-10000023	2019-04-29	Standard Class	5
266	CA-2019-109869	FUR-TA-10001889	2019-04-29	Standard Class	6
267	CA-2019-109869	OFF-BI-10000315	2019-04-29	Standard Class	5
268	CA-2019-109869	OFF-SU-10003505	2019-04-29	Standard Class	2
269	CA-2019-109869	OFF-AP-10002578	2019-04-29	Standard Class	2
270	CA-2020-154907	FUR-BO-10002824	2020-04-04	Standard Class	2
271	US-2019-100419	OFF-BI-10002194	2019-12-20	Second Class	3
272	CA-2019-103891	TEC-PH-10000149	2019-07-19	Standard Class	6
273	CA-2019-152632	FUR-FU-10002671	2019-11-02	Standard Class	3
274	CA-2019-100790	OFF-AR-10003045	2019-07-02	Standard Class	5
275	CA-2019-100790	OFF-ST-10000689	2019-07-02	Standard Class	5
276	CA-2020-140963	OFF-LA-10003923	2020-06-13	First Class	2
277	CA-2020-140963	FUR-BO-10001337	2020-06-13	First Class	5
278	CA-2020-140963	TEC-PH-10001924	2020-06-13	First Class	5
279	CA-2019-169166	TEC-AC-10000991	2019-05-14	Standard Class	2
280	US-2019-120929	FUR-TA-10001857	2019-03-21	Second Class	3
281	CA-2019-126158	OFF-BI-10002498	2019-07-31	Standard Class	8
282	CA-2019-126158	FUR-FU-10004864	2019-07-31	Standard Class	4
283	CA-2019-126158	FUR-CH-10002602	2019-07-31	Standard Class	2
284	CA-2019-126158	FUR-FU-10000073	2019-07-31	Standard Class	9
285	US-2019-105578	OFF-BI-10001670	2019-06-04	Standard Class	2
286	US-2019-105578	OFF-BI-10001658	2019-06-04	Standard Class	2
287	US-2019-105578	FUR-CH-10001215	2019-06-04	Standard Class	2
288	US-2019-105578	OFF-BI-10000831	2019-06-04	Standard Class	3
289	US-2019-105578	OFF-PA-10000357	2019-06-04	Standard Class	1
290	CA-2020-134978	OFF-BI-10003274	2020-11-15	Second Class	5
291	CA-2020-135307	FUR-FU-10001290	2020-11-27	First Class	3
292	CA-2020-135307	TEC-AC-10002399	2020-11-27	First Class	2
293	CA-2019-106341	OFF-AR-10002053	2019-10-23	First Class	3
294	CA-2020-163405	OFF-AR-10003811	2020-12-25	Standard Class	3
295	CA-2020-163405	OFF-AR-10001246	2020-12-25	Standard Class	2
296	CA-2020-127432	TEC-CO-10003236	2020-01-27	Standard Class	5
297	CA-2020-127432	OFF-ST-10004507	2020-01-27	Standard Class	3
298	CA-2020-127432	OFF-PA-10001667	2020-01-27	Standard Class	2
299	CA-2020-127432	OFF-ST-10004459	2020-01-27	Standard Class	3
300	CA-2020-145142	FUR-TA-10001857	2020-01-25	First Class	2
301	US-2019-139486	TEC-PH-10003555	2019-05-23	First Class	3
302	US-2019-139486	TEC-AC-10003832	2019-05-23	First Class	2
303	CA-2020-113558	FUR-CH-10003379	2020-10-26	Standard Class	3
304	CA-2020-113558	FUR-FU-10001756	2020-10-26	Standard Class	3
305	US-2020-129441	FUR-FU-10000448	2020-09-11	Standard Class	3
306	CA-2019-168753	TEC-PH-10000984	2019-06-01	Second Class	5
307	CA-2019-168753	OFF-BI-10002557	2019-06-01	Second Class	5
308	CA-2019-126613	OFF-ST-10001325	2019-07-16	Standard Class	2
309	US-2020-122637	OFF-BI-10002429	2020-09-08	Second Class	7
310	CA-2019-136924	TEC-PH-10002262	2019-07-17	First Class	8
311	CA-2020-162929	OFF-BI-10000404	2020-11-22	First Class	6
312	CA-2020-162929	OFF-PA-10002986	2020-11-22	First Class	2
313	CA-2019-136406	FUR-CH-10002024	2019-04-17	Second Class	2
314	CA-2020-112774	FUR-FU-10003039	2020-09-12	First Class	1
315	CA-2020-101945	OFF-FA-10004248	2020-11-28	Standard Class	3
316	CA-2020-100650	OFF-ST-10001780	2020-07-03	Second Class	2
317	CA-2019-113243	OFF-LA-10001297	2019-06-15	Standard Class	2
318	CA-2019-113243	FUR-TA-10004256	2019-06-15	Standard Class	4
319	CA-2019-113243	OFF-PA-10003441	2019-06-15	Standard Class	5
320	CA-2020-118731	FUR-FU-10003347	2020-11-22	Second Class	3
321	CA-2020-118731	OFF-BI-10000069	2020-11-22	Second Class	7
322	CA-2020-137099	TEC-PH-10002496	2020-12-10	First Class	3
323	CA-2020-156951	OFF-PA-10004530	2020-10-08	Standard Class	8
324	CA-2020-156951	OFF-BI-10001107	2020-10-08	Standard Class	7
325	CA-2020-156951	OFF-PA-10004451	2020-10-08	Standard Class	3
326	CA-2020-156951	FUR-CH-10004997	2020-10-08	Standard Class	3
327	CA-2020-164826	OFF-LA-10001297	2019-01-04	Standard Class	7
328	CA-2020-164826	OFF-FA-10000585	2019-01-04	Standard Class	4
329	CA-2020-164826	OFF-BI-10001922	2019-01-04	Standard Class	7
330	CA-2020-164826	TEC-PH-10000347	2019-01-04	Standard Class	3
331	CA-2019-127250	OFF-AR-10003394	2019-11-07	Standard Class	3
332	CA-2020-118640	OFF-ST-10002974	2020-07-26	Standard Class	2
333	CA-2020-118640	FUR-FU-10001475	2020-07-26	Standard Class	1
334	CA-2020-145233	TEC-PH-10004977	2020-12-05	Standard Class	3
335	CA-2020-145233	TEC-PH-10000586	2020-12-05	Standard Class	2
336	CA-2020-145233	OFF-AP-10000358	2020-12-05	Standard Class	3
337	CA-2020-145233	OFF-BI-10002764	2020-12-05	Standard Class	7
338	CA-2020-145233	TEC-PH-10001254	2020-12-05	Standard Class	4
339	US-2019-156986	TEC-PH-10003800	2019-03-24	Standard Class	2
340	US-2019-156986	OFF-PA-10002005	2019-03-24	Standard Class	4
341	US-2019-156986	OFF-BI-10002498	2019-03-24	Standard Class	3
342	US-2019-156986	OFF-PA-10004101	2019-03-24	Standard Class	2
343	CA-2019-120200	OFF-SU-10004115	2019-07-16	First Class	2
344	US-2019-100720	TEC-PH-10001425	2019-07-21	Standard Class	3
345	US-2019-100720	TEC-PH-10003963	2019-07-21	Standard Class	4
346	US-2019-100720	OFF-SU-10001574	2019-07-21	Standard Class	2
347	CA-2019-161816	TEC-PH-10003012	2019-05-01	First Class	3
348	CA-2019-161816	OFF-LA-10004345	2019-05-01	First Class	4
349	CA-2019-121223	OFF-PA-10001204	2019-09-13	Second Class	2
350	CA-2019-121223	TEC-PH-10004667	2019-09-13	Second Class	9
351	CA-2020-138611	TEC-PH-10000011	2020-11-17	Second Class	10
352	CA-2020-138611	OFF-BI-10002949	2020-11-17	Second Class	2
353	CA-2020-117947	FUR-FU-10003849	2020-08-23	Second Class	2
354	CA-2020-117947	FUR-FU-10000010	2020-08-23	Second Class	2
355	CA-2020-117947	OFF-BI-10002824	2020-08-23	Second Class	9
356	CA-2020-117947	TEC-PH-10002538	2020-08-23	Second Class	1
357	CA-2020-117947	FUR-FU-10000521	2020-08-23	Second Class	3
358	CA-2020-163020	FUR-FU-10000221	2020-09-19	Standard Class	7
359	CA-2020-153787	OFF-AP-10001563	2020-05-23	Standard Class	2
360	CA-2020-133431	OFF-BI-10000605	2020-12-21	Standard Class	5
361	CA-2020-133431	OFF-PA-10002615	2020-12-21	Standard Class	3
362	US-2019-135720	OFF-ST-10001963	2019-12-13	Second Class	3
363	US-2019-135720	TEC-AC-10001267	2019-12-13	Second Class	5
364	US-2019-135720	TEC-PH-10002103	2019-12-13	Second Class	4
365	CA-2020-144694	TEC-AC-10002857	2020-09-26	Second Class	3
366	CA-2020-144694	OFF-LA-10003930	2020-09-26	Second Class	3
367	US-2019-123470	OFF-BI-10001989	2019-08-21	Standard Class	3
368	US-2019-123470	OFF-AP-10003287	2019-08-21	Standard Class	3
369	CA-2019-115917	FUR-FU-10000576	2019-05-25	Standard Class	5
370	CA-2019-115917	OFF-BI-10004728	2019-05-25	Standard Class	4
371	CA-2019-147067	FUR-FU-10000732	2019-12-22	Standard Class	3
372	CA-2020-167913	OFF-ST-10000585	2020-08-03	Second Class	2
373	CA-2020-167913	OFF-LA-10002787	2020-08-03	Second Class	7
374	CA-2020-106103	TEC-AC-10003832	2020-06-15	Standard Class	4
375	US-2020-127719	OFF-PA-10001934	2020-07-25	Standard Class	1
376	CA-2020-126221	OFF-AP-10002457	2019-01-05	Standard Class	2
377	CA-2019-103947	OFF-FA-10003112	2019-04-08	Standard Class	5
378	CA-2019-103947	OFF-AP-10002350	2019-04-08	Standard Class	2
379	CA-2019-160745	FUR-FU-10001935	2019-12-16	Second Class	4
380	CA-2019-160745	TEC-PH-10003273	2019-12-16	Second Class	3
381	CA-2019-160745	TEC-AC-10001142	2019-12-16	Second Class	4
382	CA-2019-132661	OFF-PA-10000482	2019-10-29	Standard Class	10
383	CA-2020-140844	OFF-PA-10003892	2020-06-23	Standard Class	2
384	CA-2020-140844	TEC-AC-10001101	2020-06-23	Standard Class	8
385	CA-2019-137239	OFF-AP-10002439	2019-08-28	Standard Class	2
386	CA-2019-137239	OFF-BI-10002827	2019-08-28	Standard Class	2
387	CA-2019-137239	OFF-EN-10002230	2019-08-28	Standard Class	2
388	US-2019-156097	FUR-CH-10001215	2019-09-19	Same Day	2
389	US-2019-156097	OFF-BI-10004654	2019-09-19	Same Day	2
390	CA-2019-123666	OFF-ST-10001522	2019-03-30	Standard Class	5
391	CA-2019-143308	OFF-FA-10000621	2019-11-04	Same Day	3
392	CA-2020-132682	OFF-SU-10004231	2020-06-10	Second Class	3
393	CA-2020-132682	OFF-PA-10000474	2020-06-10	Second Class	3
394	CA-2020-132682	TEC-PH-10004042	2020-06-10	Second Class	3
395	US-2020-106663	FUR-FU-10002759	2020-06-13	Standard Class	3
396	US-2020-106663	FUR-TA-10000688	2020-06-13	Standard Class	1
397	US-2020-106663	OFF-PA-10002377	2020-06-13	Standard Class	8
398	CA-2020-111178	OFF-AR-10001954	2020-06-22	Standard Class	5
399	CA-2020-130351	OFF-AP-10004532	2020-12-08	First Class	3
400	CA-2020-130351	OFF-PA-10002137	2020-12-08	First Class	5
401	CA-2020-130351	TEC-AC-10003832	2020-12-08	First Class	3
402	US-2020-119438	OFF-AP-10000804	2020-03-23	Standard Class	3
403	US-2020-119438	TEC-AC-10003614	2020-03-23	Standard Class	3
404	US-2020-119438	FUR-FU-10003553	2020-03-23	Standard Class	3
405	US-2020-119438	OFF-BI-10004632	2020-03-23	Standard Class	3
406	CA-2019-164511	OFF-BI-10003305	2019-11-24	Standard Class	3
407	CA-2019-164511	OFF-ST-10002583	2019-11-24	Standard Class	2
408	CA-2019-164511	OFF-ST-10004507	2019-11-24	Standard Class	4
409	US-2020-168116	TEC-MA-10004125	2020-11-04	Same Day	4
410	US-2020-168116	OFF-AP-10002457	2020-11-04	Same Day	2
411	CA-2020-161480	FUR-BO-10004015	2020-12-29	Standard Class	2
412	CA-2020-114552	FUR-FU-10002960	2020-09-08	Standard Class	3
413	CA-2019-163755	FUR-FU-10003394	2019-11-08	Second Class	3
414	CA-2020-146136	OFF-EN-10001219	2020-09-07	Standard Class	4
415	US-2020-100048	OFF-AP-10001154	2020-05-24	Standard Class	6
416	US-2020-100048	TEC-PH-10003012	2020-05-24	Standard Class	2
417	US-2020-100048	TEC-AC-10001606	2020-05-24	Standard Class	3
418	CA-2020-108910	FUR-FU-10002253	2020-09-29	Standard Class	3
419	CA-2019-112942	OFF-PA-10004092	2019-02-18	Standard Class	3
420	CA-2019-142335	FUR-TA-10000198	2019-12-19	Standard Class	3
421	CA-2019-142335	OFF-ST-10000036	2019-12-19	Standard Class	3
422	CA-2019-114713	OFF-SU-10004664	2019-07-12	Standard Class	7
423	CA-2020-144113	OFF-EN-10001141	2020-09-20	Standard Class	2
424	CA-2020-144113	TEC-PH-10002170	2020-09-20	Standard Class	1
425	US-2019-150861	OFF-PA-10001954	2019-12-06	First Class	8
426	US-2019-150861	FUR-TA-10002228	2019-12-06	First Class	2
427	US-2019-150861	OFF-ST-10004634	2019-12-06	First Class	3
428	US-2019-150861	FUR-CH-10002965	2019-12-06	First Class	3
429	US-2019-150861	OFF-LA-10001317	2019-12-06	First Class	2
430	CA-2020-131954	OFF-ST-10000736	2020-01-25	Standard Class	3
431	CA-2020-131954	TEC-AC-10003610	2020-01-25	Standard Class	3
432	CA-2020-131954	OFF-BI-10003982	2020-01-25	Standard Class	6
433	CA-2020-131954	OFF-BI-10003291	2020-01-25	Standard Class	4
434	CA-2020-131954	FUR-BO-10001619	2020-01-25	Standard Class	1
435	CA-2020-131954	OFF-BI-10000138	2020-01-25	Standard Class	5
436	US-2019-146710	OFF-SU-10004498	2019-09-01	Standard Class	5
437	US-2019-146710	OFF-PA-10002615	2019-09-01	Standard Class	1
438	US-2019-146710	OFF-PA-10004971	2019-09-01	Standard Class	1
439	US-2019-146710	OFF-SU-10004261	2019-09-01	Standard Class	4
440	CA-2019-150889	TEC-PH-10000004	2019-03-22	Second Class	1
441	CA-2020-126074	OFF-BI-10003638	2020-10-06	Standard Class	3
442	CA-2020-126074	FUR-FU-10003577	2020-10-06	Standard Class	11
443	CA-2020-126074	OFF-AR-10003478	2020-10-06	Standard Class	7
444	CA-2020-126074	OFF-BI-10000546	2020-10-06	Standard Class	1
445	CA-2019-110499	TEC-CO-10002095	2019-04-09	First Class	3
446	CA-2019-140928	FUR-TA-10001095	2019-09-22	Standard Class	4
447	CA-2020-117240	OFF-BI-10000848	2020-07-28	Standard Class	3
448	CA-2020-133333	OFF-PA-10002377	2020-09-22	Standard Class	4
449	CA-2020-126046	OFF-LA-10004484	2020-11-07	Standard Class	3
450	CA-2019-157245	FUR-CH-10003746	2019-05-24	Standard Class	2
451	CA-2020-104220	OFF-BI-10001036	2020-02-05	Standard Class	2
452	CA-2020-104220	TEC-PH-10004614	2020-02-05	Standard Class	3
453	CA-2020-104220	OFF-BI-10000301	2020-02-05	Standard Class	5
454	CA-2020-104220	OFF-BI-10003910	2020-02-05	Standard Class	1
455	CA-2020-104220	OFF-AR-10004648	2020-02-05	Standard Class	2
456	CA-2020-104220	FUR-FU-10002597	2020-02-05	Standard Class	7
457	CA-2020-129567	OFF-BI-10000014	2020-03-21	Second Class	2
458	CA-2019-105256	TEC-PH-10001530	2019-05-20	Same Day	5
459	CA-2020-151428	OFF-BI-10000546	2020-09-26	Standard Class	7
460	CA-2020-105809	FUR-FU-10004090	2020-02-23	First Class	1
461	CA-2020-105809	TEC-PH-10001580	2020-02-23	First Class	2
462	CA-2019-136133	OFF-AP-10000576	2019-08-23	Second Class	9
463	CA-2019-115504	OFF-PA-10003953	2019-03-17	Standard Class	2
464	CA-2020-135783	FUR-FU-10000794	2020-04-24	First Class	2
465	CA-2020-143686	FUR-FU-10000794	2020-05-14	Same Day	2
466	CA-2020-143686	TEC-AC-10001838	2020-05-14	Same Day	7
467	CA-2019-149370	OFF-PA-10003651	2019-09-19	Standard Class	1
468	CA-2020-101434	TEC-AC-10002402	2020-06-27	Standard Class	3
469	CA-2020-101434	OFF-LA-10003223	2020-06-27	Standard Class	2
470	CA-2020-126956	OFF-FA-10002280	2020-08-28	Standard Class	7
471	CA-2020-126956	OFF-SU-10000381	2020-08-28	Standard Class	4
472	CA-2020-126956	OFF-EN-10004459	2020-08-28	Standard Class	2
473	CA-2020-129462	FUR-CH-10000665	2020-06-21	Second Class	2
474	CA-2020-129462	OFF-AP-10003884	2020-06-21	Second Class	3
475	CA-2020-129462	TEC-PH-10001557	2020-06-21	Second Class	2
476	CA-2020-129462	TEC-PH-10002085	2020-06-21	Second Class	1
477	CA-2019-165316	OFF-AR-10002956	2019-07-27	Standard Class	2
478	CA-2019-165316	OFF-AP-10003266	2019-07-27	Standard Class	2
479	CA-2019-165316	TEC-MA-10004002	2019-07-27	Standard Class	1
480	US-2020-156083	OFF-PA-10001560	2020-11-11	Standard Class	2
481	US-2019-137547	TEC-PH-10002365	2019-03-12	Standard Class	3
482	CA-2019-161669	OFF-BI-10001294	2019-11-09	First Class	4
483	CA-2019-161669	OFF-BI-10001636	2019-11-09	First Class	4
484	CA-2019-161669	OFF-SU-10002503	2019-11-09	First Class	2
485	CA-2019-161669	OFF-LA-10004093	2019-11-09	First Class	2
486	CA-2020-107503	FUR-FU-10003878	2020-01-06	Standard Class	4
487	CA-2019-152534	OFF-AR-10002335	2019-06-25	Second Class	2
488	CA-2019-152534	OFF-PA-10001870	2019-06-25	Second Class	6
489	CA-2019-113747	OFF-AR-10003373	2019-06-04	Standard Class	6
490	CA-2019-123274	FUR-FU-10004090	2019-02-24	Standard Class	2
491	CA-2019-123274	OFF-ST-10000736	2019-02-24	Standard Class	3
492	CA-2020-161984	OFF-PA-10004569	2020-04-15	Standard Class	1
493	CA-2020-161984	OFF-FA-10000624	2020-04-15	Standard Class	2
494	CA-2019-134474	TEC-AC-10001714	2019-01-07	Second Class	6
495	CA-2019-134474	OFF-AR-10003958	2019-01-07	Second Class	2
496	CA-2019-134474	TEC-PH-10002923	2019-01-07	Second Class	2
497	CA-2019-134362	OFF-LA-10004853	2019-10-02	First Class	4
498	CA-2019-158099	OFF-BI-10000545	2019-09-05	First Class	5
499	CA-2019-158099	TEC-PH-10002496	2019-09-05	First Class	3
500	CA-2020-114636	OFF-PA-10001790	2020-08-29	Standard Class	5
501	CA-2019-116736	FUR-FU-10004017	2019-01-21	Standard Class	3
502	CA-2019-116736	TEC-AC-10003628	2019-01-21	Standard Class	1
503	CA-2019-116736	TEC-AC-10002049	2019-01-21	Standard Class	3
\.


--
-- Data for Name: states; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.states (stateid, statename, regionid) FROM stdin;
1	Washington	3
2	Connecticut	4
3	Delaware	4
4	Ohio	4
5	Oregon	3
6	Oklahoma	5
7	Massachusetts	4
8	California	3
9	Kentucky	2
10	Pennsylvania	4
11	New Mexico	3
12	Illinois	5
13	North Carolina	2
14	Michigan	5
15	Louisiana	2
16	Mississippi	2
17	Alabama	2
18	Tennessee	2
19	Georgia	2
20	Rhode Island	4
21	Florida	2
22	Nebraska	5
23	Indiana	5
24	Iowa	5
25	New Hampshire	4
26	Minnesota	5
27	Arizona	3
28	Missouri	5
29	Wisconsin	5
30	New Jersey	4
31	Texas	5
32	Virginia	2
33	South Carolina	2
34	Montana	3
35	Nevada	3
36	New York	4
37	Colorado	3
\.


--
-- Data for Name: subcategories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subcategories (subcategoryid, subcategoryname) FROM stdin;
1	Copiers
2	Supplies
3	Labels
4	Chairs
5	Machines
6	Furnishings
7	\N
8	Tables
9	Art
10	Storage
11	Bookcases
12	Envelopes
13	Fasteners
14	Appliances
15	Accessories
16	Paper
17	Phones
18	Binders
\.


--
-- Data for Name: super_store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.super_store ("Order ID", "Order Date", "Ship Date", "Ship Mode", "Customer ID", "Customer Name", "Segment", "Country", "City", "State", "Region", "Product ID", "Category", "Sub-Category", "Product Name", "Sales", "Quantity", "Profit") FROM stdin;
CA-2019-152156	11/8/2019	11/11/2019	Second Class	CG-12520	Claire Gute	Consumer	United States	Henderson	Kentucky	South	FUR-BO-10001798	Furniture	Bookcases	Bush Somerset Collection Bookcase	261.96	2	41.9136
CA-2019-152156	11/8/2019	11/11/2019	Second Class	CG-12520	Claire Gute	Consumer	United States	Henderson	Kentucky	South	FUR-CH-10000454	Furniture	Chairs	Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back	731.94	3	219.582
CA-2019-138688	6/12/2019	6/16/2019	Second Class	DV-13045	Darrin Van Huff	Corporate	United States	Los Angeles	California	West	OFF-LA-10000240	Office Supplies	Labels	Self-Adhesive Address Labels for Typewriters by Universal	14.62	2	6.8714
CA-2020-114412	4/15/2020	4/20/2020	Standard Class	AA-10480	Andrew Allen	Consumer	United States	Concord	North Carolina	South	OFF-PA-10002365	Office Supplies	Paper	Xerox 1967	15.552	3	5.4432
CA-2019-161389	12/5/2019	12/10/2019	Standard Class	IM-15070	Irene Maddox	Consumer	United States	Seattle	Washington	West	OFF-BI-10003656	Office Supplies	Binders	Fellowes PB200 Plastic Comb Binding Machine	407.976	3	132.5922
CA-2019-137330	12/9/2019	12/13/2019	Standard Class	KB-16585	Ken Black	Corporate	United States	Fremont	Nebraska	Central	OFF-AR-10000246	Office Supplies	Art	Newell 318	19.46	7	5.0596
CA-2019-137330	12/9/2019	12/13/2019	Standard Class	KB-16585	Ken Black	Corporate	United States	Fremont	Nebraska	Central	OFF-AP-10001492	Office Supplies	Appliances	Acco Six-Outlet Power Strip, 4' Cord Length	60.34	7	15.6884
US-2020-156909	7/16/2020	7/18/2020	Second Class	SF-20065	Sandra Flanagan	Consumer	United States	Philadelphia	Pennsylvania	East	FUR-CH-10002774	Furniture	Chairs	Global Deluxe Stacking Chair, Gray	71.372	2	-1.0196
CA-2019-121755	1/16/2019	1/20/2019	Second Class	EH-13945	Eric Hoffmann	Consumer	United States	Los Angeles	California	West	OFF-BI-10001634	Office Supplies	Binders	Wilson Jones Active Use Binders	11.648	2	4.2224
CA-2019-121755	1/16/2019	1/20/2019	Second Class	EH-13945	Eric Hoffmann	Consumer	United States	Los Angeles	California	West	TEC-AC-10003027	Technology	Accessories	Imation�8GB Mini TravelDrive USB 2.0�Flash Drive	90.57	3	11.7741
CA-2020-107727	10/19/2020	10/23/2020	Second Class	MA-17560	Matt Abelman	Home Office	United States	Houston	Texas	Central	OFF-PA-10000249	Office Supplies	Paper	Easy-staple paper	29.472	3	9.9468
CA-2019-117590	12/8/2019	12/10/2019	First Class	GH-14485	Gene Hale	Corporate	United States	Richardson	Texas	Central	TEC-PH-10004977	Technology	Phones	GE 30524EE4	1097.544	7	123.4737
CA-2019-117590	12/8/2019	12/10/2019	First Class	GH-14485	Gene Hale	Corporate	United States	Richardson	Texas	Central	FUR-FU-10003664	Furniture	Furnishings	Electrix Architect's Clamp-On Swing Arm Lamp, Black	190.92	5	-147.963
CA-2020-120999	9/10/2020	9/15/2020	Standard Class	LC-16930	Linda Cazamias	Corporate	United States	Naperville	Illinois	Central	TEC-PH-10004093	Technology	Phones	Panasonic Kx-TS550	147.168	4	16.5564
CA-2019-101343	7/17/2019	7/22/2019	Standard Class	RA-19885	Ruben Ausman	Corporate	United States	Los Angeles	California	West	OFF-ST-10003479	Office Supplies	Storage	Eldon Base for stackable storage shelf, platinum	77.88	2	3.894
CA-2020-139619	9/19/2020	9/23/2020	Standard Class	ES-14080	Erin Smith	Corporate	United States	Melbourne	Florida	South	OFF-ST-10003282	Office Supplies	Storage	Advantus 10-Drawer Portable Organizer, Chrome Metal Frame, Smoke Drawers	95.616	2	9.5616
CA-2019-118255	3/11/2019	3/13/2019	First Class	ON-18715	Odella Nelson	Corporate	United States	Eagan	Minnesota	Central	TEC-AC-10000171	Technology	Accessories	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 25/Pack	45.98	2	19.7714
CA-2019-118255	3/11/2019	3/13/2019	First Class	ON-18715	Odella Nelson	Corporate	United States	Eagan	Minnesota	Central	OFF-BI-10003291	Office Supplies	Binders	Wilson Jones Leather-Like Binders with DublLock Round Rings	17.46	2	8.2062
CA-2019-169194	6/20/2019	6/25/2019	Standard Class	LH-16900	Lena Hernandez	Consumer	United States	Dover	Delaware	East	TEC-AC-10002167	Technology	Accessories	Imation�8gb Micro Traveldrive Usb 2.0�Flash Drive	45	3	4.95
CA-2019-169194	6/20/2019	6/25/2019	Standard Class	LH-16900	Lena Hernandez	Consumer	United States	Dover	Delaware	East	TEC-PH-10003988	Technology	Phones	LF Elite 3D Dazzle Designer Hard Case Cover, Lf Stylus Pen and Wiper For Apple Iphone 5c Mini Lite	21.8	2	6.104
CA-2019-105816	12/11/2019	12/17/2019	Standard Class	JM-15265	Janet Molinari	Corporate	United States	New York City	New York	East	OFF-FA-10000304	Office Supplies	Fasteners	Advantus Push Pins	15.26	7	6.2566
CA-2019-105816	12/11/2019	12/17/2019	Standard Class	JM-15265	Janet Molinari	Corporate	United States	New York City	New York	East	TEC-PH-10002447	Technology	Phones	AT&T CL83451 4-Handset Telephone	1029.95	5	298.6855
CA-2019-111682	6/17/2019	6/18/2019	First Class	TB-21055	Ted Butterfield	Consumer	United States	Troy	New York	East	OFF-ST-10000604	Office Supplies	Storage	Home/Office Personal File Carts	208.56	6	52.14
CA-2019-111682	6/17/2019	6/18/2019	First Class	TB-21055	Ted Butterfield	Consumer	United States	Troy	New York	East	OFF-PA-10001569	Office Supplies	Paper	Xerox 232	32.4	5	15.552
CA-2019-111682	6/17/2019	6/18/2019	First Class	TB-21055	Ted Butterfield	Consumer	United States	Troy	New York	East	FUR-CH-10003968	Furniture	Chairs	Novimex Turbo Task Chair	319.41	5	7.098
CA-2019-111682	6/17/2019	6/18/2019	First Class	TB-21055	Ted Butterfield	Consumer	United States	Troy	New York	East	OFF-PA-10000587	Office Supplies	Paper	Array Parchment Paper, Assorted Colors	14.56	2	6.9888
CA-2019-111682	6/17/2019	6/18/2019	First Class	TB-21055	Ted Butterfield	Consumer	United States	Troy	New York	East	TEC-AC-10002167	Technology	Accessories	Imation�8gb Micro Traveldrive Usb 2.0�Flash Drive	30	2	3.3
CA-2019-111682	6/17/2019	6/18/2019	First Class	TB-21055	Ted Butterfield	Consumer	United States	Troy	New York	East	OFF-BI-10001460	Office Supplies	Binders	Plastic Binding Combs	48.48	4	16.362
CA-2019-111682	6/17/2019	6/18/2019	First Class	TB-21055	Ted Butterfield	Consumer	United States	Troy	New York	East	OFF-AR-10001868	Office Supplies	Art	Prang Dustless Chalk Sticks	1.68	1	0.84
CA-2019-119823	6/4/2019	6/6/2019	First Class	KD-16270	Karen Daniels	Consumer	United States	Springfield	Virginia	South	OFF-PA-10000482	Office Supplies	Paper	Snap-A-Way Black Print Carbonless Ruled Speed Letter, Triplicate	75.88	2	35.6636
CA-2019-106075	9/18/2019	9/23/2019	Standard Class	HM-14980	Henry MacAllister	Consumer	United States	New York City	New York	East	OFF-BI-10004654	Office Supplies	Binders	Avery Binding System Hidden Tab Executive Style Index Sets	4.616	1	1.731
CA-2020-114440	9/14/2020	9/17/2020	Second Class	TB-21520	Tracy Blumstein	Consumer	United States	Jackson	Michigan	Central	OFF-PA-10004675	Office Supplies	Paper	Telephone Message Books with Fax/Mobile Section, 5 1/2" x 3 3/16"	19.05	3	8.763
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
US-2020-118038	12/9/2020	12/11/2020	First Class	KB-16600	Ken Brennan	Corporate	United States	Houston	Texas	Central	OFF-BI-10004182	Office Supplies	Binders	Economy Binders	1.248	3	-1.9344
US-2020-118038	12/9/2020	12/11/2020	First Class	KB-16600	Ken Brennan	Corporate	United States	Houston	Texas	Central	FUR-FU-10000260	Furniture	Furnishings	6" Cubicle Wall Clock, Black	9.708	3	-5.8248
US-2020-118038	12/9/2020	12/11/2020	First Class	KB-16600	Ken Brennan	Corporate	United States	Houston	Texas	Central	OFF-ST-10000615	Office Supplies	Storage	SimpliFile Personal File, Black Granite, 15w x 6-15/16d x 11-1/4h	27.24	3	2.724
CA-2019-127208	6/12/2019	6/15/2019	First Class	SC-20770	Stewart Carmichael	Corporate	United States	Decatur	Alabama	South	OFF-AP-10002118	Office Supplies	Appliances	1.7 Cubic Foot Compact "Cube" Office Refrigerators	208.16	1	56.2032
CA-2019-127208	6/12/2019	6/15/2019	First Class	SC-20770	Stewart Carmichael	Corporate	United States	Decatur	Alabama	South	OFF-BI-10002309	Office Supplies	Binders	Avery Heavy-Duty EZD  Binder With Locking Rings	16.74	3	8.0352
US-2020-119662	11/13/2020	11/16/2020	First Class	CS-12400	Christopher Schild	Home Office	United States	Chicago	Illinois	Central	OFF-ST-10003656	Office Supplies	Storage	Safco Industrial Wire Shelving	230.376	3	-48.9549
CA-2020-140088	5/28/2020	5/30/2020	Second Class	PO-18865	Patrick O'Donnell	Consumer	United States	Columbia	South Carolina	South	FUR-CH-10000863	Furniture	Chairs	Novimex Swivel Fabric Task Chair	301.96	2	33.2156
CA-2020-155558	10/26/2020	11/2/2020	Standard Class	PG-18895	Paul Gonzalez	Consumer	United States	Rochester	Minnesota	Central	TEC-AC-10001998	Technology	Accessories	Logitech�LS21 Speaker System - PC Multimedia - 2.1-CH - Wired	19.99	1	6.7966
CA-2020-155558	10/26/2020	11/2/2020	Standard Class	PG-18895	Paul Gonzalez	Consumer	United States	Rochester	Minnesota	Central	OFF-LA-10000134	Office Supplies	Labels	Avery 511	6.16	2	2.9568
CA-2019-159695	4/5/2019	4/10/2019	Second Class	GM-14455	Gary Mitchum	Home Office	United States	Houston	Texas	Central	OFF-ST-10003442	Office Supplies	Storage	Eldon Portable Mobile Manager	158.368	7	13.8572
CA-2019-109806	9/17/2019	9/22/2019	Standard Class	JS-15685	Jim Sink	Corporate	United States	Los Angeles	California	West	OFF-AR-10004930	Office Supplies	Art	Turquoise Lead Holder with Pocket Clip	20.1	3	6.633
CA-2019-109806	9/17/2019	9/22/2019	Standard Class	JS-15685	Jim Sink	Corporate	United States	Los Angeles	California	West	TEC-PH-10004093	Technology	Phones	Panasonic Kx-TS550	73.584	2	8.2782
CA-2019-109806	9/17/2019	9/22/2019	Standard Class	JS-15685	Jim Sink	Corporate	United States	Los Angeles	California	West	OFF-PA-10000304	Office Supplies	Paper	Xerox 1995	6.48	1	3.1104
US-2020-109484	11/6/2020	11/12/2020	Standard Class	RB-19705	Roger Barcio	Home Office	United States	Portland	Oregon	West	OFF-BI-10004738	Office Supplies	Binders	Flexible Leather- Look Classic Collection Ring Binder	5.682	1	-3.788
CA-2020-161018	11/9/2020	11/11/2020	Second Class	PN-18775	Parhena Norris	Home Office	United States	New York City	New York	East	FUR-FU-10000629	Furniture	Furnishings	9-3/4 Diameter Round Wall Clock	96.53	7	40.5426
CA-2020-157833	6/17/2020	6/20/2020	First Class	KD-16345	Katherine Ducich	Consumer	United States	San Francisco	California	West	OFF-BI-10001721	Office Supplies	Binders	Trimflex Flexible Post Binders	51.312	3	17.9592
CA-2019-149223	9/6/2019	9/11/2019	Standard Class	ER-13855	Elpida Rittenbach	Corporate	United States	Saint Paul	Minnesota	Central	OFF-AP-10000358	Office Supplies	Appliances	Fellowes Basic Home/Office Series Surge Protectors	77.88	6	22.5852
CA-2019-158568	8/29/2019	9/2/2019	Standard Class	RB-19465	Rick Bensley	Home Office	United States	Chicago	Illinois	Central	OFF-PA-10003256	Office Supplies	Paper	Avery Personal Creations Heavyweight Cards	64.624	7	22.6184
CA-2019-158568	8/29/2019	9/2/2019	Standard Class	RB-19465	Rick Bensley	Home Office	United States	Chicago	Illinois	Central	TEC-AC-10001767	Technology	Accessories	SanDisk Ultra 64 GB MicroSDHC Class 10 Memory Card	95.976	3	-10.7973
CA-2019-158568	8/29/2019	9/2/2019	Standard Class	RB-19465	Rick Bensley	Home Office	United States	Chicago	Illinois	Central	OFF-BI-10002609	Office Supplies	Binders	Avery Hidden Tab Dividers for Binding Systems	1.788	3	-3.0396
CA-2019-129903	12/1/2019	12/4/2019	Second Class	GZ-14470	Gary Zandusky	Consumer	United States	Rochester	Minnesota	Central	OFF-PA-10004040	Office Supplies	Paper	Universal Premium White Copier/Laser Paper (20Lb. and 87 Bright)	23.92	4	11.7208
CA-2020-119004	11/23/2020	11/28/2020	Standard Class	JM-15250	Janet Martin	Consumer	United States	Charlotte	North Carolina	South	TEC-AC-10003499	Technology	Accessories	Memorex Mini Travel Drive 8 GB USB 2.0 Flash Drive	74.112	8	17.6016
CA-2020-119004	11/23/2020	11/28/2020	Standard Class	JM-15250	Janet Martin	Consumer	United States	Charlotte	North Carolina	South	TEC-PH-10002844	Technology	Phones	Speck Products Candyshell Flip Case	27.992	1	2.0994
CA-2020-119004	11/23/2020	11/28/2020	Standard Class	JM-15250	Janet Martin	Consumer	United States	Charlotte	North Carolina	South	OFF-AR-10000390	Office Supplies	Art	Newell Chalk Holder	3.304	1	1.0738
CA-2020-146780	12/25/2020	12/30/2020	Standard Class	CV-12805	Cynthia Voltz	Corporate	United States	New York City	New York	East	FUR-FU-10001934	Furniture	Furnishings	Magnifier Swing Arm Lamp	41.96	2	10.9096
CA-2019-128867	11/3/2019	11/10/2019	Standard Class	CL-12565	Clay Ludtke	Consumer	United States	Urbandale	Iowa	Central	OFF-AR-10000380	Office Supplies	Art	Hunt PowerHouse Electric Pencil Sharpener, Blue	75.96	2	22.788
CA-2019-128867	11/3/2019	11/10/2019	Standard Class	CL-12565	Clay Ludtke	Consumer	United States	Urbandale	Iowa	Central	OFF-BI-10003981	Office Supplies	Binders	Avery Durable Plastic 1" Binders	27.24	6	13.3476
CA-2019-103730	6/12/2019	6/15/2019	First Class	SC-20725	Steven Cartwright	Consumer	United States	Wilmington	Delaware	East	FUR-FU-10002157	Furniture	Furnishings	Artistic Insta-Plaque	47.04	3	18.3456
CA-2019-103730	6/12/2019	6/15/2019	First Class	SC-20725	Steven Cartwright	Consumer	United States	Wilmington	Delaware	East	OFF-BI-10003910	Office Supplies	Binders	DXL Angle-View Binders with Locking Rings by Samsill	30.84	4	13.878
CA-2019-103730	6/12/2019	6/15/2019	First Class	SC-20725	Steven Cartwright	Consumer	United States	Wilmington	Delaware	East	OFF-ST-10000777	Office Supplies	Storage	Companion Letter/Legal File, Black	226.56	6	63.4368
CA-2019-103730	6/12/2019	6/15/2019	First Class	SC-20725	Steven Cartwright	Consumer	United States	Wilmington	Delaware	East	OFF-EN-10002500	Office Supplies	Envelopes	Globe Weis Peel & Seel First Class Envelopes	115.02	9	51.759
CA-2019-103730	6/12/2019	6/15/2019	First Class	SC-20725	Steven Cartwright	Consumer	United States	Wilmington	Delaware	East	TEC-PH-10003875	Technology	Phones	KLD Oscar II Style Snap-on Ultra Thin Side Flip Synthetic Leather Cover Case for HTC One HTC M7	68.04	7	19.7316
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
US-2020-107272	11/5/2020	11/12/2020	Standard Class	TS-21610	Troy Staebel	Consumer	United States	Phoenix	Arizona	West	OFF-BI-10003274	Office Supplies	Binders	Avery Durable Slant Ring Binders, No Labels	2.388	2	-1.8308
US-2020-107272	11/5/2020	11/12/2020	Standard Class	TS-21610	Troy Staebel	Consumer	United States	Phoenix	Arizona	West	OFF-ST-10002974	Office Supplies	Storage	Trav-L-File Heavy-Duty Shuttle II, Black	243.992	7	30.499
US-2019-125969	11/6/2019	11/10/2019	Second Class	LS-16975	Lindsay Shagiari	Home Office	United States	Los Angeles	California	West	FUR-CH-10001146	Furniture	Chairs	Global Task Chair, Black	81.424	2	-9.1602
US-2019-125969	11/6/2019	11/10/2019	Second Class	LS-16975	Lindsay Shagiari	Home Office	United States	Los Angeles	California	West	FUR-FU-10003773	Furniture	Furnishings	Eldon Cleatmat Plus Chair Mats for High Pile Carpets	238.56	3	26.2416
US-2020-164147	2/2/2020	2/5/2020	First Class	DW-13585	Dorothy Wardle	Corporate	United States	Columbus	Ohio	East	TEC-PH-10002293	Technology	Phones	Anker 36W 4-Port USB Wall Charger Travel Power Adapter for iPhone 5s 5c 5	59.97	5	-11.994
US-2020-164147	2/2/2020	2/5/2020	First Class	DW-13585	Dorothy Wardle	Corporate	United States	Columbus	Ohio	East	OFF-PA-10002377	Office Supplies	Paper	Xerox 1916	78.304	2	29.364
US-2020-164147	2/2/2020	2/5/2020	First Class	DW-13585	Dorothy Wardle	Corporate	United States	Columbus	Ohio	East	OFF-FA-10002780	Office Supplies	Fasteners	Staples	21.456	9	6.9732
CA-2019-145583	10/13/2019	10/19/2019	Standard Class	LC-16885	Lena Creighton	Consumer	United States	Roseville	California	West	OFF-PA-10001804	Office Supplies	Paper	Xerox 195	20.04	3	9.6192
CA-2019-145583	10/13/2019	10/19/2019	Standard Class	LC-16885	Lena Creighton	Consumer	United States	Roseville	California	West	OFF-PA-10001736	Office Supplies	Paper	Xerox 1880	35.44	1	16.6568
CA-2019-145583	10/13/2019	10/19/2019	Standard Class	LC-16885	Lena Creighton	Consumer	United States	Roseville	California	West	OFF-AR-10001149	Office Supplies	Art	Sanford Colorific Colored Pencils, 12/Box	11.52	4	3.456
CA-2019-145583	10/13/2019	10/19/2019	Standard Class	LC-16885	Lena Creighton	Consumer	United States	Roseville	California	West	OFF-FA-10002988	Office Supplies	Fasteners	Ideal Clamps	4.02	2	1.9698
CA-2019-145583	10/13/2019	10/19/2019	Standard Class	LC-16885	Lena Creighton	Consumer	United States	Roseville	California	West	OFF-BI-10004781	Office Supplies	Binders	GBC Wire Binding Strips	76.176	3	26.6616
CA-2019-145583	10/13/2019	10/19/2019	Standard Class	LC-16885	Lena Creighton	Consumer	United States	Roseville	California	West	OFF-SU-10001218	Office Supplies	Supplies	Fiskars Softgrip Scissors	65.88	6	18.4464
CA-2019-145583	10/13/2019	10/19/2019	Standard Class	LC-16885	Lena Creighton	Consumer	United States	Roseville	California	West	FUR-FU-10001706	Furniture	Furnishings	Longer-Life Soft White Bulbs	43.12	14	20.6976
CA-2019-110366	9/5/2019	9/7/2019	Second Class	JD-15895	Jonathan Doherty	Corporate	United States	Philadelphia	Pennsylvania	East	FUR-FU-10004848	Furniture	Furnishings	Howard Miller 13-3/4" Diameter Brushed Chrome Round Wall Clock	82.8	2	10.35
CA-2020-106180	9/18/2020	9/23/2020	Standard Class	SH-19975	Sally Hughsby	Corporate	United States	San Francisco	California	West	OFF-AR-10000940	Office Supplies	Art	Newell 343	8.82	3	2.3814
CA-2020-106180	9/18/2020	9/23/2020	Standard Class	SH-19975	Sally Hughsby	Corporate	United States	San Francisco	California	West	OFF-EN-10004030	Office Supplies	Envelopes	Convenience Packs of Business Envelopes	10.86	3	5.1042
CA-2020-106180	9/18/2020	9/23/2020	Standard Class	SH-19975	Sally Hughsby	Corporate	United States	San Francisco	California	West	OFF-PA-10004327	Office Supplies	Paper	Xerox 1911	143.7	3	68.976
CA-2020-155376	12/22/2020	12/27/2020	Standard Class	SG-20080	Sandra Glassco	Consumer	United States	Independence	Missouri	Central	OFF-AP-10001058	Office Supplies	Appliances	Sanyo 2.5 Cubic Foot Mid-Size Office Refrigerators	839.43	3	218.2518
CA-2019-114489	12/5/2019	12/9/2019	Standard Class	JE-16165	Justin Ellison	Corporate	United States	Franklin	Wisconsin	Central	TEC-PH-10000215	Technology	Phones	Plantronics Cordless�Phone Headset�with In-line Volume - M214C	384.45	11	103.8015
CA-2019-114489	12/5/2019	12/9/2019	Standard Class	JE-16165	Justin Ellison	Corporate	United States	Franklin	Wisconsin	Central	TEC-PH-10001448	Technology	Phones	Anker Astro 15000mAh USB Portable Charger	149.97	3	5.9988
CA-2019-114489	12/5/2019	12/9/2019	Standard Class	JE-16165	Justin Ellison	Corporate	United States	Franklin	Wisconsin	Central	FUR-CH-10000454	Furniture	Chairs	Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back	1951.84	8	585.552
CA-2019-114489	12/5/2019	12/9/2019	Standard Class	JE-16165	Justin Ellison	Corporate	United States	Franklin	Wisconsin	Central	OFF-BI-10002735	Office Supplies	Binders	GBC Prestige Therm-A-Bind Covers	171.55	5	80.6285
CA-2019-158834	3/13/2019	3/16/2019	First Class	TW-21025	Tamara Willingham	Home Office	United States	Scottsdale	Arizona	West	OFF-AP-10000326	Office Supplies	Appliances	Belkin 7 Outlet SurgeMaster Surge Protector with Phone Protection	157.92	5	17.766
CA-2019-158834	3/13/2019	3/16/2019	First Class	TW-21025	Tamara Willingham	Home Office	United States	Scottsdale	Arizona	West	TEC-PH-10001254	Technology	Phones	Jabra BIZ 2300 Duo QD Duo Corded�Headset	203.184	2	15.2388
CA-2019-114104	11/20/2019	11/24/2019	Standard Class	NP-18670	Nora Paige	Consumer	United States	Edmond	Oklahoma	Central	OFF-LA-10002475	Office Supplies	Labels	Avery 519	14.62	2	6.8714
CA-2019-114104	11/20/2019	11/24/2019	Standard Class	NP-18670	Nora Paige	Consumer	United States	Edmond	Oklahoma	Central	TEC-PH-10004536	Technology	Phones	Avaya 5420 Digital phone	944.93	7	236.2325
CA-2019-162733	5/11/2019	5/12/2019	First Class	TT-21070	Ted Trevino	Consumer	United States	Los Angeles	California	West	OFF-PA-10002751	Office Supplies	Paper	Xerox 1920	5.98	1	2.691
CA-2019-154508	11/16/2019	11/20/2019	Standard Class	RD-19900	Ruben Dartt	Consumer	United States	Carlsbad	New Mexico	West	OFF-EN-10001990	Office Supplies	Envelopes	Staple envelope	28.4	5	13.348
CA-2019-113817	11/7/2019	11/11/2019	Standard Class	MJ-17740	Max Jones	Consumer	United States	Seattle	Washington	West	OFF-BI-10004002	Office Supplies	Binders	Wilson Jones International Size A4 Ring Binders	27.68	2	9.688
US-2020-152366	4/21/2020	4/25/2020	Second Class	SJ-20500	Shirley Jackson	Consumer	United States	Houston	Texas	Central	OFF-AP-10002684	Office Supplies	Appliances	Acco 7-Outlet Masterpiece Power Center, Wihtout Fax/Phone Line Protection	97.264	4	-243.16
CA-2019-105018	11/28/2019	12/2/2019	Standard Class	SK-19990	Sally Knutson	Consumer	United States	Fairfield	Connecticut	East	OFF-BI-10001890	Office Supplies	Binders	Avery Poly Binder Pockets	7.16	2	3.4368
CA-2019-157000	7/16/2019	7/22/2019	Standard Class	AM-10360	Alice McCarthy	Corporate	United States	Grand Prairie	Texas	Central	OFF-ST-10001328	Office Supplies	Storage	Personal Filing Tote with Lid, Black/Gray	37.224	3	3.7224
CA-2019-157000	7/16/2019	7/22/2019	Standard Class	AM-10360	Alice McCarthy	Corporate	United States	Grand Prairie	Texas	Central	OFF-PA-10001950	Office Supplies	Paper	Southworth 25% Cotton Antique Laid Paper & Envelopes	20.016	3	6.255
CA-2020-107720	11/6/2020	11/13/2020	Standard Class	VM-21685	Valerie Mitchum	Home Office	United States	Westfield	New Jersey	East	OFF-ST-10001414	Office Supplies	Storage	Decoflex Hanging Personal Folder File	46.26	3	12.0276
US-2020-124303	7/6/2020	7/13/2020	Standard Class	FH-14365	Fred Hopkins	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-BI-10000343	Office Supplies	Binders	Pressboard Covers with Storage Hooks, 9 1/2" x 11", Light Blue	2.946	2	-2.2586
US-2020-124303	7/6/2020	7/13/2020	Standard Class	FH-14365	Fred Hopkins	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-PA-10002749	Office Supplies	Paper	Wirebound Message Books, 5-1/2 x 4 Forms, 2 or 4 Forms per Page	16.056	3	5.8203
CA-2020-105074	6/24/2020	6/29/2020	Standard Class	MB-17305	Maria Bertelson	Consumer	United States	Akron	Ohio	East	OFF-PA-10002666	Office Supplies	Paper	Southworth 25% Cotton Linen-Finish Paper & Envelopes	21.744	3	6.795
US-2020-116701	12/17/2020	12/21/2020	Second Class	LC-17140	Logan Currie	Consumer	United States	Dallas	Texas	Central	OFF-AP-10003217	Office Supplies	Appliances	Eureka Sanitaire  Commercial Upright	66.284	2	-178.9668
CA-2020-126382	6/3/2020	6/7/2020	Standard Class	HK-14890	Heather Kirkland	Corporate	United States	Franklin	Tennessee	South	FUR-FU-10002960	Furniture	Furnishings	Eldon 200 Class Desk Accessories, Burgundy	35.168	7	9.6712
CA-2020-108329	12/9/2020	12/14/2020	Standard Class	LE-16810	Laurel Elliston	Consumer	United States	Whittier	California	West	TEC-PH-10001918	Technology	Phones	Nortel Business Series Terminal T7208 Digital phone	444.768	4	44.4768
CA-2020-135860	12/1/2020	12/7/2020	Standard Class	JH-15985	Joseph Holt	Consumer	United States	Saginaw	Michigan	Central	OFF-ST-10000642	Office Supplies	Storage	Tennsco Lockers, Gray	83.92	4	5.8744
CA-2020-135860	12/1/2020	12/7/2020	Standard Class	JH-15985	Joseph Holt	Consumer	United States	Saginaw	Michigan	Central	TEC-PH-10001700	Technology	Phones	Panasonic KX-TG6844B Expandable Digital Cordless Telephone	131.98	2	35.6346
CA-2020-135860	12/1/2020	12/7/2020	Standard Class	JH-15985	Joseph Holt	Consumer	United States	Saginaw	Michigan	Central	OFF-BI-10003274	Office Supplies	Binders	Avery Durable Slant Ring Binders, No Labels	15.92	4	7.4824
CA-2020-135860	12/1/2020	12/7/2020	Standard Class	JH-15985	Joseph Holt	Consumer	United States	Saginaw	Michigan	Central	OFF-FA-10000134	Office Supplies	Fasteners	Advantus Push Pins, Aluminum Head	52.29	9	16.2099
CA-2020-135860	12/1/2020	12/7/2020	Standard Class	JH-15985	Joseph Holt	Consumer	United States	Saginaw	Michigan	Central	OFF-ST-10001522	Office Supplies	Storage	Gould Plastics 18-Pocket Panel Bin, 34w x 5-1/4d x 20-1/2h	91.99	1	3.6796
CA-2019-130162	10/28/2019	11/1/2019	Standard Class	JH-15910	Jonathan Howell	Consumer	United States	Los Angeles	California	West	OFF-ST-10001328	Office Supplies	Storage	Personal Filing Tote with Lid, Black/Gray	93.06	6	26.0568
CA-2019-130162	10/28/2019	11/1/2019	Standard Class	JH-15910	Jonathan Howell	Consumer	United States	Los Angeles	California	West	TEC-PH-10002563	Technology	Phones	Adtran 1202752G1	302.376	3	22.6782
US-2020-100930	4/7/2020	4/12/2020	Standard Class	CS-12400	Christopher Schild	Home Office	United States	Tampa	Florida	South	FUR-TA-10001705	Furniture	Tables	Bush Advantage Collection Round Conference Table	233.86	2	-102.048
US-2020-100930	4/7/2020	4/12/2020	Standard Class	CS-12400	Christopher Schild	Home Office	United States	Tampa	Florida	South	FUR-TA-10003473	Furniture	Tables	Bretford Rectangular Conference Table Tops	620.6145	3	-248.2458
US-2020-100930	4/7/2020	4/12/2020	Standard Class	CS-12400	Christopher Schild	Home Office	United States	Tampa	Florida	South	OFF-BI-10001679	Office Supplies	Binders	GBC Instant Index System for Binding Systems	5.328	2	-3.552
US-2020-100930	4/7/2020	4/12/2020	Standard Class	CS-12400	Christopher Schild	Home Office	United States	Tampa	Florida	South	FUR-FU-10004017	Furniture	Furnishings	Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39" x 49"	258.072	3	0
US-2020-100930	4/7/2020	4/12/2020	Standard Class	CS-12400	Christopher Schild	Home Office	United States	Tampa	Florida	South	TEC-AC-10003832	Technology	Accessories	Logitech�P710e Mobile Speakerphone	617.976	3	-7.7247
CA-2020-160514	11/12/2020	11/16/2020	Standard Class	DB-13120	David Bremer	Corporate	United States	Santa Clara	California	West	OFF-PA-10002479	Office Supplies	Paper	Xerox 4200 Series MultiUse Premium Copy Paper (20Lb. and 84 Bright)	10.56	2	4.752
CA-2019-157749	6/4/2019	6/9/2019	Second Class	KL-16645	Ken Lonsdale	Consumer	United States	Chicago	Illinois	Central	OFF-PA-10003349	Office Supplies	Paper	Xerox 1957	25.92	5	9.396
CA-2019-157749	6/4/2019	6/9/2019	Second Class	KL-16645	Ken Lonsdale	Consumer	United States	Chicago	Illinois	Central	FUR-FU-10000576	Furniture	Furnishings	Luxo Professional Fluorescent Magnifier Lamp with Clamp-Mount Base	419.68	5	-356.728
CA-2019-157749	6/4/2019	6/9/2019	Second Class	KL-16645	Ken Lonsdale	Consumer	United States	Chicago	Illinois	Central	FUR-FU-10004351	Furniture	Furnishings	Staple-based wall hangings	11.688	3	-4.6752
CA-2019-157749	6/4/2019	6/9/2019	Second Class	KL-16645	Ken Lonsdale	Consumer	United States	Chicago	Illinois	Central	TEC-PH-10000011	Technology	Phones	PureGear Roll-On Screen Protector	31.984	2	11.1944
CA-2019-157749	6/4/2019	6/9/2019	Second Class	KL-16645	Ken Lonsdale	Consumer	United States	Chicago	Illinois	Central	FUR-TA-10002607	Furniture	Tables	KI Conference Tables	177.225	5	-120.513
CA-2019-157749	6/4/2019	6/9/2019	Second Class	KL-16645	Ken Lonsdale	Consumer	United States	Chicago	Illinois	Central	FUR-FU-10002505	Furniture	Furnishings	Eldon 100 Class Desk Accessories	4.044	3	-2.8308
CA-2019-157749	6/4/2019	6/9/2019	Second Class	KL-16645	Ken Lonsdale	Consumer	United States	Chicago	Illinois	Central	OFF-AR-10004685	Office Supplies	Art	Binney & Smith Crayola Metallic Colored Pencils, 8-Color Set	7.408	2	1.2038
CA-2019-154739	12/10/2019	12/15/2019	Second Class	LH-17155	Logan Haushalter	Consumer	United States	San Francisco	California	West	FUR-CH-10002965	Furniture	Chairs	Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black	321.568	2	28.1372
CA-2019-145625	9/11/2019	9/17/2019	Standard Class	KC-16540	Kelly Collister	Consumer	United States	San Diego	California	West	OFF-PA-10004569	Office Supplies	Paper	Wirebound Message Books, Two 4 1/4" x 5" Forms per Page	7.61	1	3.5767
CA-2019-145625	9/11/2019	9/17/2019	Standard Class	KC-16540	Kelly Collister	Consumer	United States	San Diego	California	West	TEC-AC-10003832	Technology	Accessories	Logitech�P710e Mobile Speakerphone	3347.37	13	636.0003
CA-2019-146941	12/10/2019	12/13/2019	First Class	DL-13315	Delfina Latchford	Consumer	United States	New York City	New York	East	OFF-ST-10001228	Office Supplies	Storage	Fellowes Personal Hanging Folder Files, Navy	80.58	6	22.5624
CA-2019-146941	12/10/2019	12/13/2019	First Class	DL-13315	Delfina Latchford	Consumer	United States	New York City	New York	East	OFF-EN-10003296	Office Supplies	Envelopes	Tyvek Side-Opening Peel & Seel Expanding Envelopes	361.92	4	162.864
CA-2020-163139	12/1/2020	12/3/2020	Second Class	CC-12670	Craig Carreira	Consumer	United States	New York City	New York	East	TEC-AC-10000290	Technology	Accessories	Sabrent 4-Port USB 2.0 Hub	20.37	3	6.9258
CA-2020-163139	12/1/2020	12/3/2020	Second Class	CC-12670	Craig Carreira	Consumer	United States	New York City	New York	East	OFF-ST-10002790	Office Supplies	Storage	Safco Industrial Shelving	221.55	3	6.6465
CA-2020-163139	12/1/2020	12/3/2020	Second Class	CC-12670	Craig Carreira	Consumer	United States	New York City	New York	East	OFF-BI-10003460	Office Supplies	Binders	Acco 3-Hole Punch	17.52	5	6.132
US-2020-155299	6/8/2020	6/12/2020	Standard Class	Dl-13600	Dorris liebe	Corporate	United States	Pasadena	Texas	Central	OFF-AP-10002203	Office Supplies	Appliances	Eureka Disposable Bags for Sanitaire Vibra Groomer I Upright Vac	1.624	2	-4.466
CA-2019-125318	6/6/2019	6/13/2019	Standard Class	RC-19825	Roy Collins	Consumer	United States	Chicago	Illinois	Central	TEC-PH-10001433	Technology	Phones	Cisco Small Business SPA 502G VoIP phone	328.224	4	28.7196
CA-2020-136826	6/16/2020	6/20/2020	Standard Class	CB-12535	Claudia Bergmann	Corporate	United States	Chapel Hill	North Carolina	South	OFF-AR-10003602	Office Supplies	Art	Quartet Omega Colored Chalk, 12/Pack	14.016	3	4.7304
CA-2019-111010	1/22/2019	1/28/2019	Standard Class	PG-18895	Paul Gonzalez	Consumer	United States	Morristown	New Jersey	East	OFF-FA-10003472	Office Supplies	Fasteners	Bagged Rubber Bands	7.56	6	0.3024
US-2020-145366	12/9/2020	12/13/2020	Standard Class	CA-12310	Christine Abelman	Corporate	United States	Cincinnati	Ohio	East	OFF-ST-10004180	Office Supplies	Storage	Safco Commercial Shelving	37.208	1	-7.4416
US-2020-145366	12/9/2020	12/13/2020	Standard Class	CA-12310	Christine Abelman	Corporate	United States	Cincinnati	Ohio	East	OFF-EN-10004386	Office Supplies	Envelopes	Recycled Interoffice Envelopes with String and Button Closure, 10 x 13	57.576	3	21.591
CA-2020-163979	12/28/2020	1/2/2019	Second Class	KH-16690	Kristen Hastings	Corporate	United States	San Francisco	California	West	OFF-ST-10003208	Office Supplies	Storage	Adjustable Depth Letter/Legal Cart	725.84	4	210.4936
CA-2020-118136	9/16/2020	9/17/2020	First Class	BB-10990	Barry Blumstein	Corporate	United States	Inglewood	California	West	OFF-PA-10002615	Office Supplies	Paper	Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled	8.82	2	4.0572
CA-2020-118136	9/16/2020	9/17/2020	First Class	BB-10990	Barry Blumstein	Corporate	United States	Inglewood	California	West	OFF-AR-10001427	Office Supplies	Art	Newell 330	5.98	1	1.5548
CA-2020-132976	10/13/2020	10/17/2020	Standard Class	AG-10495	Andrew Gjertsen	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-PA-10000673	Office Supplies	Paper	Post-it ?Important Message? Note Pad, Neon Colors, 50 Sheets/Pad	11.648	2	4.0768
CA-2020-132976	10/13/2020	10/17/2020	Standard Class	AG-10495	Andrew Gjertsen	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-PA-10004470	Office Supplies	Paper	Adams Write n' Stick Phone Message Book, 11" X 5 1/4", 200 Messages	18.176	4	5.9072
CA-2020-132976	10/13/2020	10/17/2020	Standard Class	AG-10495	Andrew Gjertsen	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-ST-10000876	Office Supplies	Storage	Eldon Simplefile Box Office	59.712	6	5.9712
CA-2020-132976	10/13/2020	10/17/2020	Standard Class	AG-10495	Andrew Gjertsen	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-LA-10002043	Office Supplies	Labels	Avery 489	24.84	3	8.694
CA-2019-112697	12/18/2019	12/20/2019	Second Class	AH-10195	Alan Haines	Corporate	United States	Tamarac	Florida	South	OFF-BI-10000778	Office Supplies	Binders	GBC VeloBinder Electric Binding Machine	254.058	7	-169.372
CA-2019-112697	12/18/2019	12/20/2019	Second Class	AH-10195	Alan Haines	Corporate	United States	Tamarac	Florida	South	OFF-AP-10002684	Office Supplies	Appliances	Acco 7-Outlet Masterpiece Power Center, Wihtout Fax/Phone Line Protection	194.528	2	24.316
CA-2019-112697	12/18/2019	12/20/2019	Second Class	AH-10195	Alan Haines	Corporate	United States	Tamarac	Florida	South	OFF-SU-10000646	Office Supplies	Supplies	Premier Automatic Letter Opener	961.48	5	-204.3145
CA-2019-110772	11/20/2019	11/24/2019	Second Class	NZ-18565	Nick Zandusky	Home Office	United States	Columbus	Ohio	East	OFF-FA-10002983	Office Supplies	Fasteners	Advantus SlideClip Paper Clips	19.096	7	6.6836
CA-2019-110772	11/20/2019	11/24/2019	Second Class	NZ-18565	Nick Zandusky	Home Office	United States	Columbus	Ohio	East	OFF-LA-10004689	Office Supplies	Labels	Avery 512	18.496	8	6.2424
CA-2019-110772	11/20/2019	11/24/2019	Second Class	NZ-18565	Nick Zandusky	Home Office	United States	Columbus	Ohio	East	TEC-AC-10002001	Technology	Accessories	Logitech Wireless Gaming Headset G930	255.984	2	54.3966
CA-2019-110772	11/20/2019	11/24/2019	Second Class	NZ-18565	Nick Zandusky	Home Office	United States	Columbus	Ohio	East	FUR-BO-10004709	Furniture	Bookcases	Bush Westfield Collection Bookcases, Medium Cherry Finish	86.97	3	-48.7032
CA-2019-142545	10/28/2019	11/3/2019	Standard Class	JD-15895	Jonathan Doherty	Corporate	United States	Belleville	New Jersey	East	OFF-PA-10002105	Office Supplies	Paper	Xerox 223	32.4	5	15.552
CA-2019-142545	10/28/2019	11/3/2019	Standard Class	JD-15895	Jonathan Doherty	Corporate	United States	Belleville	New Jersey	East	OFF-ST-10002756	Office Supplies	Storage	Tennsco Stur-D-Stor Boltless Shelving, 5 Shelves, 24" Deep, Sand	1082.48	8	10.8248
CA-2019-142545	10/28/2019	11/3/2019	Standard Class	JD-15895	Jonathan Doherty	Corporate	United States	Belleville	New Jersey	East	OFF-PA-10004243	Office Supplies	Paper	Xerox 1939	56.91	3	27.3168
CA-2019-142545	10/28/2019	11/3/2019	Standard Class	JD-15895	Jonathan Doherty	Corporate	United States	Belleville	New Jersey	East	FUR-FU-10001861	Furniture	Furnishings	Floodlight Indoor Halogen Bulbs, 1 Bulb per Pack, 60 Watts	77.6	4	38.024
CA-2019-142545	10/28/2019	11/3/2019	Standard Class	JD-15895	Jonathan Doherty	Corporate	United States	Belleville	New Jersey	East	OFF-BI-10002706	Office Supplies	Binders	Avery Premier Heavy-Duty Binder with Round Locking Rings	14.28	1	6.5688
US-2020-152380	11/19/2020	11/23/2020	Standard Class	JH-15910	Jonathan Howell	Consumer	United States	Chicago	Illinois	Central	FUR-TA-10002533	Furniture	Tables	BPI Conference Tables	219.075	3	-131.445
CA-2020-126774	4/15/2020	4/17/2020	First Class	SH-20395	Shahid Hopkins	Consumer	United States	Arlington	Virginia	South	OFF-AR-10002804	Office Supplies	Art	Faber Castell Col-Erase Pencils	4.89	1	2.0049
CA-2019-142902	9/12/2019	9/14/2019	Second Class	BP-11185	Ben Peterman	Corporate	United States	Arvada	Colorado	West	FUR-FU-10001918	Furniture	Furnishings	C-Line Cubicle Keepers Polyproplyene Holder With Velcro Backings	15.136	4	3.5948
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2019-142902	9/12/2019	9/14/2019	Second Class	BP-11185	Ben Peterman	Corporate	United States	Arvada	Colorado	West	FUR-CH-10004086	Furniture	Chairs	Hon 4070 Series Pagoda Armless Upholstered Stacking Chairs	466.768	2	52.5114
CA-2019-142902	9/12/2019	9/14/2019	Second Class	BP-11185	Ben Peterman	Corporate	United States	Arvada	Colorado	West	FUR-FU-10001756	Furniture	Furnishings	Eldon Expressions Desk Accessory, Wood Photo Frame, Mahogany	15.232	1	1.7136
CA-2019-142902	9/12/2019	9/14/2019	Second Class	BP-11185	Ben Peterman	Corporate	United States	Arvada	Colorado	West	OFF-LA-10000634	Office Supplies	Labels	Avery 509	6.264	3	2.0358
CA-2019-162138	4/23/2019	4/27/2019	Standard Class	GK-14620	Grace Kelly	Corporate	United States	Hesperia	California	West	OFF-BI-10004593	Office Supplies	Binders	Ibico Laser Imprintable Binding System Covers	251.52	6	81.744
CA-2019-162138	4/23/2019	4/27/2019	Standard Class	GK-14620	Grace Kelly	Corporate	United States	Hesperia	California	West	TEC-AC-10001908	Technology	Accessories	Logitech Wireless Headset h800	99.99	1	34.9965
CA-2020-153339	11/3/2020	11/5/2020	Second Class	DJ-13510	Don Jones	Corporate	United States	Murfreesboro	Tennessee	South	FUR-FU-10001967	Furniture	Furnishings	Telescoping Adjustable Floor Lamp	15.992	1	0.9995
US-2019-141544	8/30/2019	9/1/2019	First Class	PO-18850	Patrick O'Brill	Consumer	United States	Philadelphia	Pennsylvania	East	TEC-PH-10003645	Technology	Phones	Aastra 57i VoIP phone	290.898	3	-67.8762
US-2019-141544	8/30/2019	9/1/2019	First Class	PO-18850	Patrick O'Brill	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-ST-10000675	Office Supplies	Storage	File Shuttle II and Handi-File, Black	54.224	2	3.389
US-2019-141544	8/30/2019	9/1/2019	First Class	PO-18850	Patrick O'Brill	Consumer	United States	Philadelphia	Pennsylvania	East	FUR-CH-10003312	Furniture	Chairs	Hon 2090 ?Pillow Soft? Series Mid Back Swivel/Tilt Chairs	786.744	4	-258.5016
US-2019-141544	8/30/2019	9/1/2019	First Class	PO-18850	Patrick O'Brill	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-LA-10001074	Office Supplies	Labels	Round Specialty Laser Printer Labels	100.24	10	33.831
US-2019-141544	8/30/2019	9/1/2019	First Class	PO-18850	Patrick O'Brill	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-BI-10001524	Office Supplies	Binders	GBC Premium Transparent Covers with Diagonal Lined Pattern	37.764	6	-27.6936
US-2019-150147	4/25/2019	4/29/2019	Second Class	JL-15850	John Lucas	Consumer	United States	Philadelphia	Pennsylvania	East	TEC-PH-10004614	Technology	Phones	AT&T 841000 Phone	82.8	2	-20.7
US-2019-150147	4/25/2019	4/29/2019	Second Class	JL-15850	John Lucas	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-BI-10001153	Office Supplies	Binders	Ibico Recycled Grain-Textured Covers	20.724	2	-13.816
US-2019-150147	4/25/2019	4/29/2019	Second Class	JL-15850	John Lucas	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-BI-10001982	Office Supplies	Binders	Wilson Jones Custom Binder Spines & Labels	4.896	3	-3.4272
CA-2020-169901	6/15/2020	6/19/2020	Standard Class	CC-12550	Clay Cheatham	Consumer	United States	San Francisco	California	West	TEC-PH-10002293	Technology	Phones	Anker 36W 4-Port USB Wall Charger Travel Power Adapter for iPhone 5s 5c 5	47.976	3	4.7976
CA-2020-134306	7/8/2020	7/12/2020	Standard Class	TD-20995	Tamara Dahlen	Consumer	United States	Lowell	Massachusetts	East	OFF-AR-10004027	Office Supplies	Art	Binney & Smith inkTank Erasable Desk Highlighter, Chisel Tip, Yellow, 12/Box	7.56	3	3.0996
CA-2020-134306	7/8/2020	7/12/2020	Standard Class	TD-20995	Tamara Dahlen	Consumer	United States	Lowell	Massachusetts	East	OFF-PA-10000249	Office Supplies	Paper	Easy-staple paper	24.56	2	11.5432
CA-2020-134306	7/8/2020	7/12/2020	Standard Class	TD-20995	Tamara Dahlen	Consumer	United States	Lowell	Massachusetts	East	OFF-AR-10001374	Office Supplies	Art	BIC Brite Liner Highlighters, Chisel Tip	12.96	2	4.1472
CA-2019-129714	9/1/2019	9/3/2019	First Class	AB-10060	Adam Bellavance	Home Office	United States	New York City	New York	East	TEC-AC-10000290	Technology	Accessories	Sabrent 4-Port USB 2.0 Hub	6.79	1	2.3086
CA-2019-129714	9/1/2019	9/3/2019	First Class	AB-10060	Adam Bellavance	Home Office	United States	New York City	New York	East	OFF-PA-10001970	Office Supplies	Paper	Xerox 1881	24.56	2	11.5432
CA-2019-129714	9/1/2019	9/3/2019	First Class	AB-10060	Adam Bellavance	Home Office	United States	New York City	New York	East	OFF-BI-10002160	Office Supplies	Binders	Acco Hanging Data Binders	3.048	1	1.0668
CA-2019-129714	9/1/2019	9/3/2019	First Class	AB-10060	Adam Bellavance	Home Office	United States	New York City	New York	East	OFF-PA-10001970	Office Supplies	Paper	Xerox 1881	49.12	4	23.0864
CA-2019-129714	9/1/2019	9/3/2019	First Class	AB-10060	Adam Bellavance	Home Office	United States	New York City	New York	East	OFF-BI-10004995	Office Supplies	Binders	GBC DocuBind P400 Electric Binding System	4355.168	4	1415.4296
CA-2019-138520	4/8/2019	4/13/2019	Standard Class	JL-15505	Jeremy Lonsdale	Consumer	United States	New York City	New York	East	FUR-BO-10002268	Furniture	Bookcases	Sauder Barrister Bookcases	388.704	6	-4.8588
CA-2019-138520	4/8/2019	4/13/2019	Standard Class	JL-15505	Jeremy Lonsdale	Consumer	United States	New York City	New York	East	OFF-EN-10001137	Office Supplies	Envelopes	#10 Gummed Flap White Envelopes, 100/Box	8.26	2	3.7996
CA-2019-138520	4/8/2019	4/13/2019	Standard Class	JL-15505	Jeremy Lonsdale	Consumer	United States	New York City	New York	East	OFF-AR-10002399	Office Supplies	Art	Dixon Prang Watercolor Pencils, 10-Color Set with Brush	17.04	4	6.9864
CA-2019-138520	4/8/2019	4/13/2019	Standard Class	JL-15505	Jeremy Lonsdale	Consumer	United States	New York City	New York	East	OFF-PA-10002713	Office Supplies	Paper	Adams Phone Message Book, 200 Message Capacity, 8 1/16? x 11?	34.4	5	15.824
CA-2019-130001	4/23/2019	4/28/2019	Standard Class	HK-14890	Heather Kirkland	Corporate	United States	Charlotte	North Carolina	South	OFF-PA-10002666	Office Supplies	Paper	Southworth 25% Cotton Linen-Finish Paper & Envelopes	36.24	5	11.325
CA-2020-155698	3/8/2020	3/11/2020	First Class	VB-21745	Victoria Brennan	Corporate	United States	Columbus	Georgia	South	OFF-AP-10001124	Office Supplies	Appliances	Belkin 8 Outlet SurgeMaster II Gold Surge Protector with Phone Protection	647.84	8	168.4384
CA-2020-155698	3/8/2020	3/11/2020	First Class	VB-21745	Victoria Brennan	Corporate	United States	Columbus	Georgia	South	OFF-LA-10001158	Office Supplies	Labels	Avery Address/Shipping Labels for Typewriters, 4" x 2"	20.7	2	9.936
CA-2020-144904	9/25/2020	10/1/2020	Standard Class	KW-16435	Katrina Willman	Consumer	United States	New York City	New York	East	OFF-LA-10001158	Office Supplies	Labels	Avery Address/Shipping Labels for Typewriters, 4" x 2"	20.7	2	9.936
CA-2020-144904	9/25/2020	10/1/2020	Standard Class	KW-16435	Katrina Willman	Consumer	United States	New York City	New York	East	FUR-CH-10000785	Furniture	Chairs	Global Ergonomic Managers Chair	488.646	3	86.8704
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2020-144904	9/25/2020	10/1/2020	Standard Class	KW-16435	Katrina Willman	Consumer	United States	New York City	New York	East	OFF-AR-10003732	Office Supplies	Art	Newell 333	5.56	2	1.4456
CA-2020-144904	9/25/2020	10/1/2020	Standard Class	KW-16435	Katrina Willman	Consumer	United States	New York City	New York	East	FUR-FU-10000023	Furniture	Furnishings	Eldon Wave Desk Accessories	47.12	8	20.7328
CA-2019-155516	10/21/2019	10/21/2019	Same Day	MK-17905	Michael Kennedy	Corporate	United States	Manchester	Connecticut	East	OFF-BI-10002412	Office Supplies	Binders	Wilson Jones ?Snap? Scratch Pad Binder Tool for Ring Binders	23.2	4	10.44
CA-2019-155516	10/21/2019	10/21/2019	Same Day	MK-17905	Michael Kennedy	Corporate	United States	Manchester	Connecticut	East	OFF-SU-10001225	Office Supplies	Supplies	Staple remover	7.36	2	0.1472
CA-2019-155516	10/21/2019	10/21/2019	Same Day	MK-17905	Michael Kennedy	Corporate	United States	Manchester	Connecticut	East	OFF-ST-10002406	Office Supplies	Storage	Pizazz Global Quick File	104.79	7	29.3412
CA-2019-155516	10/21/2019	10/21/2019	Same Day	MK-17905	Michael Kennedy	Corporate	United States	Manchester	Connecticut	East	FUR-BO-10002545	Furniture	Bookcases	Atlantic Metals Mobile 3-Shelf Bookcases, Custom Colors	1043.92	4	271.4192
CA-2020-104745	5/29/2020	6/4/2020	Standard Class	GT-14755	Guy Thornton	Consumer	United States	Harlingen	Texas	Central	OFF-PA-10002036	Office Supplies	Paper	Xerox 1930	25.92	5	9.396
CA-2020-104745	5/29/2020	6/4/2020	Standard Class	GT-14755	Guy Thornton	Consumer	United States	Harlingen	Texas	Central	OFF-ST-10002205	Office Supplies	Storage	File Shuttle I and Handi-File	53.424	3	4.6746
US-2019-134656	9/28/2019	10/1/2019	First Class	MM-18280	Muhammed MacIntyre	Corporate	United States	Quincy	Illinois	Central	OFF-PA-10003039	Office Supplies	Paper	Xerox 1960	99.136	4	30.98
US-2020-134481	8/27/2020	9/1/2020	Standard Class	AR-10405	Allen Rosenblatt	Corporate	United States	Franklin	Massachusetts	East	FUR-TA-10004915	Furniture	Tables	Office Impressions End Table, 20-1/2"H x 24"W x 20"D	1488.424	7	-297.6848
CA-2019-134775	10/28/2019	10/29/2019	First Class	AS-10285	Alejandro Savely	Corporate	United States	San Francisco	California	West	OFF-PA-10004734	Office Supplies	Paper	Southworth Structures Collection	50.96	7	25.48
CA-2019-134775	10/28/2019	10/29/2019	First Class	AS-10285	Alejandro Savely	Corporate	United States	San Francisco	California	West	OFF-BI-10002225	Office Supplies	Binders	Square Ring Data Binders, Rigid 75 Pt. Covers, 11" x 14-7/8"	49.536	3	17.3376
CA-2020-101798	12/11/2020	12/15/2020	Standard Class	MV-18190	Mike Vittorini	Consumer	United States	New York City	New York	East	OFF-BI-10000050	Office Supplies	Binders	Angle-D Binders with Locking Rings, Label Holders	23.36	4	7.884
CA-2020-101798	12/11/2020	12/15/2020	Standard Class	MV-18190	Mike Vittorini	Consumer	United States	New York City	New York	East	TEC-AC-10001998	Technology	Accessories	Logitech�LS21 Speaker System - PC Multimedia - 2.1-CH - Wired	39.98	2	13.5932
CA-2020-102946	6/30/2020	7/5/2020	Standard Class	VP-21730	Victor Preis	Home Office	United States	Las Vegas	Nevada	West	OFF-BI-10004492	Office Supplies	Binders	Tuf-Vin Binders	75.792	3	25.5798
CA-2020-165603	10/17/2020	10/19/2020	Second Class	SS-20140	Saphhira Shifley	Corporate	United States	Warwick	Rhode Island	East	OFF-ST-10000798	Office Supplies	Storage	2300 Heavy-Duty Transfer File Systems by Perma	49.96	2	9.4924
CA-2020-165603	10/17/2020	10/19/2020	Second Class	SS-20140	Saphhira Shifley	Corporate	United States	Warwick	Rhode Island	East	OFF-PA-10002552	Office Supplies	Paper	Xerox 1958	12.96	2	6.2208
CA-2019-108987	9/8/2019	9/10/2019	Second Class	AG-10675	Anna Gayman	Consumer	United States	Houston	Texas	Central	OFF-ST-10001580	Office Supplies	Storage	Super Decoflex Portable Personal File	35.952	3	3.5952
CA-2019-108987	9/8/2019	9/10/2019	Second Class	AG-10675	Anna Gayman	Consumer	United States	Houston	Texas	Central	FUR-BO-10004834	Furniture	Bookcases	Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish	2396.2656	4	-317.1528
CA-2019-108987	9/8/2019	9/10/2019	Second Class	AG-10675	Anna Gayman	Consumer	United States	Houston	Texas	Central	OFF-ST-10000934	Office Supplies	Storage	Contico 72"H Heavy-Duty Storage System	131.136	4	-32.784
CA-2019-108987	9/8/2019	9/10/2019	Second Class	AG-10675	Anna Gayman	Consumer	United States	Houston	Texas	Central	TEC-AC-10000158	Technology	Accessories	Sony 64GB Class 10 Micro SDHC R40 Memory Card	57.584	2	0.7198
CA-2020-117933	12/24/2020	12/29/2020	Standard Class	RF-19840	Roy Franz�sisch	Consumer	United States	New York City	New York	East	OFF-AP-10004249	Office Supplies	Appliances	Staple holder	35.91	3	9.6957
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	TEC-AC-10000158	Technology	Accessories	Sony 64GB Class 10 Micro SDHC R40 Memory Card	179.95	5	37.7895
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	TEC-CO-10004115	Technology	Copiers	Sharp AL-1530CS Digital Copier	1199.976	3	434.9913
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	OFF-PA-10003724	Office Supplies	Paper	Wirebound Message Book, 4 per Page	27.15	5	13.3035
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	FUR-TA-10002041	Furniture	Tables	Bevis Round Conference Table Top, X-Base	1004.024	7	-112.9527
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	OFF-PA-10002893	Office Supplies	Paper	Wirebound Service Call Books, 5 1/2" x 4"	9.68	1	4.6464
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	OFF-LA-10003766	Office Supplies	Labels	Self-Adhesive Removable Labels	28.35	9	13.608
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	OFF-PA-10001970	Office Supplies	Paper	Xerox 1908	55.98	1	27.4302
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	FUR-BO-10001972	Furniture	Bookcases	O'Sullivan 4-Shelf Bookcase in Odessa Pine	1336.829	13	31.4548
CA-2020-117457	12/8/2020	12/12/2020	Standard Class	KH-16510	Keith Herrera	Consumer	United States	San Francisco	California	West	FUR-CH-10003956	Furniture	Chairs	Novimex High-Tech Fabric Mesh Task Chair	113.568	2	-18.4548
CA-2020-142636	11/3/2020	11/7/2020	Standard Class	KC-16675	Kimberly Carter	Corporate	United States	Seattle	Washington	West	OFF-PA-10000157	Office Supplies	Paper	Xerox 191	139.86	7	65.7342
CA-2020-142636	11/3/2020	11/7/2020	Standard Class	KC-16675	Kimberly Carter	Corporate	United States	Seattle	Washington	West	FUR-CH-10001891	Furniture	Chairs	Global Deluxe Office Fabric Chairs	307.136	4	26.8744
CA-2020-122105	6/24/2020	6/28/2020	Standard Class	CJ-12010	Caroline Jumper	Consumer	United States	Huntington Beach	California	West	OFF-AR-10004344	Office Supplies	Art	Bulldog Vacuum Base Pencil Sharpener	95.92	8	25.8984
CA-2019-148796	4/14/2019	4/18/2019	Standard Class	PB-19150	Philip Brown	Consumer	United States	Los Angeles	California	West	FUR-CH-10004886	Furniture	Chairs	Bevis Steel Folding Chairs	383.8	5	38.38
CA-2020-154816	11/6/2020	11/10/2020	Standard Class	VB-21745	Victoria Brennan	Corporate	United States	Richmond	Kentucky	South	OFF-PA-10003845	Office Supplies	Paper	Xerox 1987	5.78	1	2.8322
CA-2020-110478	3/4/2020	3/9/2020	Standard Class	SP-20860	Sung Pak	Corporate	United States	Los Angeles	California	West	OFF-AR-10001573	Office Supplies	Art	American Pencil	9.32	4	2.7028
CA-2020-110478	3/4/2020	3/9/2020	Standard Class	SP-20860	Sung Pak	Corporate	United States	Los Angeles	California	West	OFF-EN-10000483	Office Supplies	Envelopes	White Envelopes, White Envelopes with Clear Poly Window	15.25	1	7.015
CA-2020-125388	10/19/2020	10/23/2020	Standard Class	MP-17965	Michael Paige	Corporate	United States	Lawrence	Massachusetts	East	FUR-FU-10004712	Furniture	Furnishings	Westinghouse Mesh Shade Clip-On Gooseneck Lamp, Black	56.56	4	14.7056
CA-2020-125388	10/19/2020	10/23/2020	Standard Class	MP-17965	Michael Paige	Corporate	United States	Lawrence	Massachusetts	East	OFF-ST-10000918	Office Supplies	Storage	Crate-A-Files	32.7	3	8.502
CA-2020-155705	8/21/2020	8/23/2020	Second Class	NF-18385	Natalie Fritzler	Consumer	United States	Jackson	Mississippi	South	FUR-CH-10000015	Furniture	Chairs	Hon Multipurpose Stacking Arm Chairs	866.4	4	225.264
CA-2020-149160	11/23/2020	11/26/2020	Second Class	JM-15265	Janet Molinari	Corporate	United States	Canton	Michigan	Central	FUR-FU-10003347	Furniture	Furnishings	Coloredge Poster Frame	28.4	2	11.076
CA-2020-149160	11/23/2020	11/26/2020	Second Class	JM-15265	Janet Molinari	Corporate	United States	Canton	Michigan	Central	OFF-BI-10001543	Office Supplies	Binders	GBC VeloBinder Manual Binding System	287.92	8	138.2016
CA-2020-152275	10/1/2020	10/8/2020	Standard Class	KH-16630	Ken Heidel	Corporate	United States	San Antonio	Texas	Central	OFF-AR-10000369	Office Supplies	Art	Design Ebony Sketching Pencil	6.672	6	0.5004
US-2019-123750	4/15/2019	4/21/2019	Standard Class	RB-19795	Ross Baird	Home Office	United States	Gastonia	North Carolina	South	OFF-BI-10004584	Office Supplies	Binders	GBC ProClick 150 Presentation Binding System	189.588	2	-145.3508
US-2019-123750	4/15/2019	4/21/2019	Standard Class	RB-19795	Ross Baird	Home Office	United States	Gastonia	North Carolina	South	TEC-AC-10004659	Technology	Accessories	Imation�Secure+ Hardware Encrypted USB 2.0�Flash Drive; 16GB	408.744	7	76.6395
US-2019-123750	4/15/2019	4/21/2019	Standard Class	RB-19795	Ross Baird	Home Office	United States	Gastonia	North Carolina	South	TEC-AC-10004659	Technology	Accessories	Imation�Secure+ Hardware Encrypted USB 2.0�Flash Drive; 16GB	291.96	5	54.7425
US-2019-123750	4/15/2019	4/21/2019	Standard Class	RB-19795	Ross Baird	Home Office	United States	Gastonia	North Carolina	South	OFF-ST-10000617	Office Supplies	Storage	Woodgrain Magazine Files by Perma	4.768	2	-0.7748
CA-2019-127369	6/6/2019	6/7/2019	First Class	DB-13060	Dave Brooks	Consumer	United States	Lowell	Massachusetts	East	OFF-ST-10003306	Office Supplies	Storage	Letter Size Cart	714.3	5	207.147
CA-2019-147375	6/12/2019	6/14/2019	Second Class	PO-19180	Philisse Overcash	Home Office	United States	Chicago	Illinois	Central	TEC-MA-10002937	Technology	Machines	Canon Color ImageCLASS MF8580Cdw Wireless Laser All-In-One Printer, Copier, Scanner	1007.979	3	43.1991
CA-2019-147375	6/12/2019	6/14/2019	Second Class	PO-19180	Philisse Overcash	Home Office	United States	Chicago	Illinois	Central	OFF-PA-10001970	Office Supplies	Paper	Xerox 1908	313.488	7	113.6394
CA-2020-130043	9/15/2020	9/19/2020	Standard Class	BB-11545	Brenda Bowman	Corporate	United States	Houston	Texas	Central	OFF-PA-10002230	Office Supplies	Paper	Xerox 1897	31.872	8	11.5536
CA-2020-157252	1/20/2020	1/23/2020	Second Class	CV-12805	Cynthia Voltz	Corporate	United States	New York City	New York	East	FUR-CH-10003396	Furniture	Chairs	Global Deluxe Steno Chair	207.846	3	2.3094
CA-2019-115756	9/5/2019	9/7/2019	Second Class	PK-19075	Pete Kriz	Consumer	United States	Detroit	Michigan	Central	FUR-FU-10000246	Furniture	Furnishings	Aluminum Document Frame	12.22	1	3.666
CA-2019-115756	9/5/2019	9/7/2019	Second Class	PK-19075	Pete Kriz	Consumer	United States	Detroit	Michigan	Central	OFF-ST-10000060	Office Supplies	Storage	Fellowes Bankers Box Staxonsteel Drawer File/Stacking System	194.94	3	23.3928
CA-2019-115756	9/5/2019	9/7/2019	Second Class	PK-19075	Pete Kriz	Consumer	United States	Detroit	Michigan	Central	OFF-ST-10003058	Office Supplies	Storage	Eldon Mobile Mega Data Cart  Mega Stackable  Add-On Trays	70.95	3	20.5755
CA-2019-115756	9/5/2019	9/7/2019	Second Class	PK-19075	Pete Kriz	Consumer	United States	Detroit	Michigan	Central	OFF-PA-10002222	Office Supplies	Paper	Xerox Color Copier Paper, 11" x 17", Ream	91.36	4	42.0256
CA-2019-115756	9/5/2019	9/7/2019	Second Class	PK-19075	Pete Kriz	Consumer	United States	Detroit	Michigan	Central	FUR-CH-10002372	Furniture	Chairs	Office Star - Ergonomically Designed Knee Chair	242.94	3	29.1528
CA-2019-115756	9/5/2019	9/7/2019	Second Class	PK-19075	Pete Kriz	Consumer	United States	Detroit	Michigan	Central	OFF-LA-10001317	Office Supplies	Labels	Avery 520	22.05	7	10.584
CA-2020-154214	3/20/2020	3/25/2020	Second Class	TB-21595	Troy Blackwell	Consumer	United States	Columbus	Indiana	Central	FUR-FU-10000206	Furniture	Furnishings	GE General Purpose, Extra Long Life, Showcase & Floodlight Incandescent Bulbs	2.91	1	1.3677
CA-2019-166674	4/1/2019	4/3/2019	Second Class	RB-19360	Raymond Buch	Consumer	United States	Auburn	New York	East	OFF-AR-10000588	Office Supplies	Art	Newell 345	59.52	3	15.4752
CA-2019-166674	4/1/2019	4/3/2019	Second Class	RB-19360	Raymond Buch	Consumer	United States	Auburn	New York	East	OFF-ST-10001469	Office Supplies	Storage	Fellowes Bankers Box Recycled Super Stor/Drawer	161.94	3	9.7164
CA-2019-166674	4/1/2019	4/3/2019	Second Class	RB-19360	Raymond Buch	Consumer	United States	Auburn	New York	East	OFF-AR-10001953	Office Supplies	Art	Boston 1645 Deluxe Heavier-Duty Electric Pencil Sharpener	263.88	6	71.2476
CA-2019-166674	4/1/2019	4/3/2019	Second Class	RB-19360	Raymond Buch	Consumer	United States	Auburn	New York	East	OFF-AR-10003156	Office Supplies	Art	50 Colored Long Pencils	30.48	3	7.9248
CA-2019-166674	4/1/2019	4/3/2019	Second Class	RB-19360	Raymond Buch	Consumer	United States	Auburn	New York	East	OFF-AR-10004974	Office Supplies	Art	Newell 342	9.84	3	2.8536
CA-2019-166674	4/1/2019	4/3/2019	Second Class	RB-19360	Raymond Buch	Consumer	United States	Auburn	New York	East	TEC-PH-10002365	Technology	Phones	Belkin Grip Candy Sheer Case / Cover for iPhone 5 and 5S	35.12	4	9.1312
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2020-147277	10/20/2020	10/24/2020	Standard Class	EB-13705	Ed Braxton	Corporate	United States	Akron	Ohio	East	FUR-TA-10001539	Furniture	Tables	Chromcraft Rectangular Conference Tables	284.364	2	-75.8304
CA-2020-147277	10/20/2020	10/24/2020	Standard Class	EB-13705	Ed Braxton	Corporate	United States	Akron	Ohio	East	OFF-ST-10000142	Office Supplies	Storage	Deluxe Rollaway Locking File with Drawer	665.408	2	66.5408
CA-2019-100153	12/13/2019	12/17/2019	Standard Class	KH-16630	Ken Heidel	Corporate	United States	Norman	Oklahoma	Central	TEC-AC-10001772	Technology	Accessories	Memorex Mini Travel Drive 16 GB USB 2.0 Flash Drive	63.88	4	24.9132
US-2019-157945	9/26/2019	10/1/2019	Standard Class	NF-18385	Natalie Fritzler	Consumer	United States	Decatur	Illinois	Central	FUR-CH-10002331	Furniture	Chairs	Hon 4700 Series Mobuis Mid-Back Task Chairs with Adjustable Arms	747.558	3	-96.1146
US-2019-157945	9/26/2019	10/1/2019	Standard Class	NF-18385	Natalie Fritzler	Consumer	United States	Decatur	Illinois	Central	OFF-EN-10001415	Office Supplies	Envelopes	Staple envelope	8.928	2	3.348
CA-2019-109869	4/22/2019	4/29/2019	Standard Class	TN-21040	Tanja Norvell	Home Office	United States	Phoenix	Arizona	West	FUR-FU-10000023	Furniture	Furnishings	Eldon Wave Desk Accessories	23.56	5	7.068
CA-2019-109869	4/22/2019	4/29/2019	Standard Class	TN-21040	Tanja Norvell	Home Office	United States	Phoenix	Arizona	West	FUR-TA-10001889	Furniture	Tables	Bush Advantage Collection Racetrack Conference Table	1272.63	6	-814.4832
CA-2019-109869	4/22/2019	4/29/2019	Standard Class	TN-21040	Tanja Norvell	Home Office	United States	Phoenix	Arizona	West	OFF-BI-10000315	Office Supplies	Binders	Poly Designer Cover & Back	28.485	5	-20.889
CA-2019-109869	4/22/2019	4/29/2019	Standard Class	TN-21040	Tanja Norvell	Home Office	United States	Phoenix	Arizona	West	OFF-SU-10003505	Office Supplies	Supplies	Premier Electric Letter Opener	185.376	2	-34.758
CA-2019-109869	4/22/2019	4/29/2019	Standard Class	TN-21040	Tanja Norvell	Home Office	United States	Phoenix	Arizona	West	OFF-AP-10002578	Office Supplies	Appliances	Fellowes Premier Superior Surge Suppressor, 10-Outlet, With Phone and Remote	78.272	2	5.8704
CA-2020-154907	3/31/2020	4/4/2020	Standard Class	DS-13180	David Smith	Corporate	United States	Amarillo	Texas	Central	FUR-BO-10002824	Furniture	Bookcases	Bush Mission Pointe Library	205.3328	2	-36.2352
US-2019-100419	12/16/2019	12/20/2019	Second Class	CC-12670	Craig Carreira	Consumer	United States	Chicago	Illinois	Central	OFF-BI-10002194	Office Supplies	Binders	Cardinal Hold-It CD Pocket	4.788	3	-7.9002
CA-2019-103891	7/12/2019	7/19/2019	Standard Class	KH-16690	Kristen Hastings	Corporate	United States	Los Angeles	California	West	TEC-PH-10000149	Technology	Phones	Cisco SPA525G2 IP Phone - Wireless	95.76	6	7.182
CA-2019-152632	10/27/2019	11/2/2019	Standard Class	JE-15475	Jeremy Ellison	Consumer	United States	Troy	New York	East	FUR-FU-10002671	Furniture	Furnishings	Electrix 20W Halogen Replacement Bulb for Zoom-In Desk Lamp	40.2	3	19.296
CA-2019-100790	6/26/2019	7/2/2019	Standard Class	JG-15805	John Grady	Corporate	United States	New York City	New York	East	OFF-AR-10003045	Office Supplies	Art	Prang Colored Pencils	14.7	5	6.615
CA-2019-100790	6/26/2019	7/2/2019	Standard Class	JG-15805	John Grady	Corporate	United States	New York City	New York	East	OFF-ST-10000689	Office Supplies	Storage	Fellowes Strictly Business Drawer File, Letter/Legal Size	704.25	5	84.51
CA-2020-140963	6/10/2020	6/13/2020	First Class	MT-18070	Michelle Tran	Home Office	United States	Los Angeles	California	West	OFF-LA-10003923	Office Supplies	Labels	Alphabetical Labels for Top Tab Filing	29.6	2	14.8
CA-2020-140963	6/10/2020	6/13/2020	First Class	MT-18070	Michelle Tran	Home Office	United States	Los Angeles	California	West	FUR-BO-10001337	Furniture	Bookcases	O'Sullivan Living Dimensions 2-Shelf Bookcases	514.165	5	-30.245
CA-2020-140963	6/10/2020	6/13/2020	First Class	MT-18070	Michelle Tran	Home Office	United States	Los Angeles	California	West	TEC-PH-10001924	Technology	Phones	iHome FM Clock Radio with Lightning Dock	279.96	5	17.4975
CA-2019-169166	5/9/2019	5/14/2019	Standard Class	SS-20590	Sonia Sunley	Consumer	United States	Seattle	Washington	West	TEC-AC-10000991	Technology	Accessories	Sony Micro Vault Click 8 GB USB 2.0 Flash Drive	93.98	2	13.1572
US-2019-120929	3/18/2019	3/21/2019	Second Class	RO-19780	Rose O'Brian	Consumer	United States	Memphis	Tennessee	South	FUR-TA-10001857	Furniture	Tables	Balt Solid Wood Rectangular Table	189.882	3	-94.941
CA-2019-126158	7/25/2019	7/31/2019	Standard Class	SC-20095	Sanjit Chand	Consumer	United States	Costa Mesa	California	West	OFF-BI-10002498	Office Supplies	Binders	Clear Mylar Reinforcing Strips	119.616	8	40.3704
CA-2019-126158	7/25/2019	7/31/2019	Standard Class	SC-20095	Sanjit Chand	Consumer	United States	Costa Mesa	California	West	FUR-FU-10004864	Furniture	Furnishings	Howard Miller 14-1/2" Diameter Chrome Round Wall Clock	255.76	4	81.8432
CA-2019-126158	7/25/2019	7/31/2019	Standard Class	SC-20095	Sanjit Chand	Consumer	United States	Costa Mesa	California	West	FUR-CH-10002602	Furniture	Chairs	DMI Arturo Collection Mission-style Design Wood Chair	241.568	2	18.1176
CA-2019-126158	7/25/2019	7/31/2019	Standard Class	SC-20095	Sanjit Chand	Consumer	United States	Costa Mesa	California	West	FUR-FU-10000073	Furniture	Furnishings	Deflect-O Glasstique Clear Desk Accessories	69.3	9	22.869
US-2019-105578	5/30/2019	6/4/2019	Standard Class	MY-17380	Maribeth Yedwab	Corporate	United States	Parker	Colorado	West	OFF-BI-10001670	Office Supplies	Binders	Vinyl Sectional Post Binders	22.62	2	-15.08
US-2019-105578	5/30/2019	6/4/2019	Standard Class	MY-17380	Maribeth Yedwab	Corporate	United States	Parker	Colorado	West	OFF-BI-10001658	Office Supplies	Binders	GBC Standard Therm-A-Bind Covers	14.952	2	-11.9616
US-2019-105578	5/30/2019	6/4/2019	Standard Class	MY-17380	Maribeth Yedwab	Corporate	United States	Parker	Colorado	West	FUR-CH-10001215	Furniture	Chairs	Global Troy Executive Leather Low-Back Tilter	801.568	2	50.098
US-2019-105578	5/30/2019	6/4/2019	Standard Class	MY-17380	Maribeth Yedwab	Corporate	United States	Parker	Colorado	West	OFF-BI-10000831	Office Supplies	Binders	Storex Flexible Poly Binders with Double Pockets	2.376	3	-1.9008
US-2019-105578	5/30/2019	6/4/2019	Standard Class	MY-17380	Maribeth Yedwab	Corporate	United States	Parker	Colorado	West	OFF-PA-10000357	Office Supplies	Paper	White Dual Perf Computer Printout Paper, 2700 Sheets, 1 Part, Heavyweight, 20 lbs., 14 7/8 x 11	32.792	1	11.8871
CA-2020-134978	11/12/2020	11/15/2020	Second Class	EB-13705	Ed Braxton	Corporate	United States	New York City	New York	East	OFF-BI-10003274	Office Supplies	Binders	Avery Durable Slant Ring Binders, No Labels	15.92	5	5.373
CA-2020-135307	11/26/2020	11/27/2020	First Class	LS-17245	Lynn Smith	Consumer	United States	Gladstone	Missouri	Central	FUR-FU-10001290	Furniture	Furnishings	Executive Impressions Supervisor Wall Clock	126.3	3	40.416
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2020-135307	11/26/2020	11/27/2020	First Class	LS-17245	Lynn Smith	Consumer	United States	Gladstone	Missouri	Central	TEC-AC-10002399	Technology	Accessories	SanDisk Cruzer 32 GB USB Flash Drive	38.04	2	12.1728
CA-2019-106341	10/20/2019	10/23/2019	First Class	LF-17185	Luke Foster	Consumer	United States	Newark	Ohio	East	OFF-AR-10002053	Office Supplies	Art	Premium Writing Pencils, Soft, #2 by Central Association for the Blind	7.152	3	0.7152
CA-2020-163405	12/21/2020	12/25/2020	Standard Class	BN-11515	Bradley Nguyen	Consumer	United States	Los Angeles	California	West	OFF-AR-10003811	Office Supplies	Art	Newell 327	6.63	3	1.7901
CA-2020-163405	12/21/2020	12/25/2020	Standard Class	BN-11515	Bradley Nguyen	Consumer	United States	Los Angeles	California	West	OFF-AR-10001246	Office Supplies	Art	Newell 317	5.88	2	1.7052
CA-2020-127432	1/22/2020	1/27/2020	Standard Class	AD-10180	Alan Dominguez	Home Office	United States	Great Falls	Montana	West	TEC-CO-10003236	Technology	Copiers	Canon Image Class D660 Copier	2999.95	5	1379.977
CA-2020-127432	1/22/2020	1/27/2020	Standard Class	AD-10180	Alan Dominguez	Home Office	United States	Great Falls	Montana	West	OFF-ST-10004507	Office Supplies	Storage	Advantus Rolling Storage Box	51.45	3	13.8915
CA-2020-127432	1/22/2020	1/27/2020	Standard Class	AD-10180	Alan Dominguez	Home Office	United States	Great Falls	Montana	West	OFF-PA-10001667	Office Supplies	Paper	Great White Multi-Use Recycled Paper (20Lb. and 84 Bright)	11.96	2	5.382
CA-2020-127432	1/22/2020	1/27/2020	Standard Class	AD-10180	Alan Dominguez	Home Office	United States	Great Falls	Montana	West	OFF-ST-10004459	Office Supplies	Storage	Tennsco Single-Tier Lockers	1126.02	3	56.301
CA-2020-145142	1/23/2020	1/25/2020	First Class	MC-17605	Matt Connell	Corporate	United States	Detroit	Michigan	Central	FUR-TA-10001857	Furniture	Tables	Balt Solid Wood Rectangular Table	210.98	2	21.098
US-2019-139486	5/21/2019	5/23/2019	First Class	LH-17155	Logan Haushalter	Consumer	United States	Los Angeles	California	West	TEC-PH-10003555	Technology	Phones	Motorola HK250 Universal Bluetooth Headset	55.176	3	-12.4146
US-2019-139486	5/21/2019	5/23/2019	First Class	LH-17155	Logan Haushalter	Consumer	United States	Los Angeles	California	West	TEC-AC-10003832	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	66.26	2	27.1666
CA-2020-113558	10/21/2020	10/26/2020	Standard Class	PH-18790	Patricia Hirasaki	Home Office	United States	Lakeland	Florida	South	FUR-CH-10003379	Furniture	Chairs	Global Commerce Series High-Back Swivel/Tilt Chairs	683.952	3	42.747
CA-2020-113558	10/21/2020	10/26/2020	Standard Class	PH-18790	Patricia Hirasaki	Home Office	United States	Lakeland	Florida	South	FUR-FU-10001756	Furniture	Furnishings	Eldon Expressions Desk Accessory, Wood Photo Frame, Mahogany	45.696	3	5.1408
US-2020-129441	9/7/2020	9/11/2020	Standard Class	JC-15340	Jasper Cacioppo	Consumer	United States	Los Angeles	California	West	FUR-FU-10000448	Furniture	Furnishings	Tenex Chairmats For Use With Carpeted Floors	47.94	3	2.397
CA-2019-168753	5/29/2019	6/1/2019	Second Class	RL-19615	Rob Lucas	Consumer	United States	Montgomery	Alabama	South	TEC-PH-10000984	Technology	Phones	Panasonic KX-TG9471B	979.95	5	274.386
CA-2019-168753	5/29/2019	6/1/2019	Second Class	RL-19615	Rob Lucas	Consumer	United States	Montgomery	Alabama	South	OFF-BI-10002557	Office Supplies	Binders	Presstex Flexible Ring Binders	22.75	5	11.375
CA-2019-126613	7/10/2019	7/16/2019	Standard Class	AA-10375	Allen Armold	Consumer	United States	Mesa	Arizona	West	OFF-ST-10001325	Office Supplies	Storage	Sterilite Officeware Hinged File Box	16.768	2	1.4672
US-2020-122637	9/3/2020	9/8/2020	Second Class	EP-13915	Emily Phan	Consumer	United States	Chicago	Illinois	Central	OFF-BI-10002429	Office Supplies	Binders	Premier Elliptical Ring Binder, Black	42.616	7	-68.1856
CA-2019-136924	7/14/2019	7/17/2019	First Class	ES-14080	Erin Smith	Corporate	United States	Tucson	Arizona	West	TEC-PH-10002262	Technology	Phones	LG Electronics Tone+ HBS-730 Bluetooth Headset	380.864	8	38.0864
CA-2020-162929	11/19/2020	11/22/2020	First Class	AS-10135	Adrian Shami	Home Office	United States	New York City	New York	East	OFF-BI-10000404	Office Supplies	Binders	Avery Printable Repositionable Plastic Tabs	41.28	6	13.932
CA-2020-162929	11/19/2020	11/22/2020	First Class	AS-10135	Adrian Shami	Home Office	United States	New York City	New York	East	OFF-PA-10002986	Office Supplies	Paper	Xerox 1898	13.36	2	6.4128
CA-2019-136406	4/15/2019	4/17/2019	Second Class	BD-11320	Bill Donatelli	Consumer	United States	San Francisco	California	West	FUR-CH-10002024	Furniture	Chairs	HON 5400 Series Task Chairs for Big and Tall	1121.568	2	0
CA-2020-112774	9/11/2020	9/12/2020	First Class	RC-19960	Ryan Crowe	Consumer	United States	Jacksonville	Florida	South	FUR-FU-10003039	Furniture	Furnishings	Howard Miller 11-1/2" Diameter Grantwood Wall Clock	34.504	1	6.0382
CA-2020-101945	11/24/2020	11/28/2020	Standard Class	GT-14710	Greg Tran	Consumer	United States	Houston	Texas	Central	OFF-FA-10004248	Office Supplies	Fasteners	Advantus T-Pin Paper Clips	10.824	3	2.5707
CA-2020-100650	6/29/2020	7/3/2020	Second Class	DK-13225	Dean Katz	Corporate	United States	Anaheim	California	West	OFF-ST-10001780	Office Supplies	Storage	Tennsco 16-Compartment Lockers with Coat Rack	1295.78	2	310.9872
CA-2019-113243	6/10/2019	6/15/2019	Standard Class	OT-18730	Olvera Toch	Consumer	United States	Los Angeles	California	West	OFF-LA-10001297	Office Supplies	Labels	Avery 473	20.7	2	9.936
CA-2019-113243	6/10/2019	6/15/2019	Standard Class	OT-18730	Olvera Toch	Consumer	United States	Los Angeles	California	West	FUR-TA-10004256	Furniture	Tables	Bretford ?Just In Time? Height-Adjustable Multi-Task Work Tables	1335.68	4	-217.048
CA-2019-113243	6/10/2019	6/15/2019	Standard Class	OT-18730	Olvera Toch	Consumer	United States	Los Angeles	California	West	OFF-PA-10003441	Office Supplies	Paper	Xerox 226	32.4	5	15.552
CA-2020-118731	11/20/2020	11/22/2020	Second Class	LP-17080	Liz Pelletier	Consumer	United States	San Francisco	California	West	FUR-FU-10003347	Furniture	Furnishings	Coloredge Poster Frame	42.6	3	16.614
CA-2020-118731	11/20/2020	11/22/2020	Second Class	LP-17080	Liz Pelletier	Consumer	United States	San Francisco	California	West	OFF-BI-10000069	Office Supplies	Binders	GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb	84.056	7	27.3182
CA-2020-137099	12/7/2020	12/10/2020	First Class	FP-14320	Frank Preis	Consumer	United States	Los Angeles	California	West	TEC-PH-10002496	Technology	Phones	Cisco SPA301	374.376	3	46.797
CA-2020-156951	10/1/2020	10/8/2020	Standard Class	EB-13840	Ellis Ballard	Corporate	United States	Seattle	Washington	West	OFF-PA-10004530	Office Supplies	Paper	Personal Creations Ink Jet Cards and Labels	91.84	8	45.0016
CA-2020-156951	10/1/2020	10/8/2020	Standard Class	EB-13840	Ellis Ballard	Corporate	United States	Seattle	Washington	West	OFF-BI-10001107	Office Supplies	Binders	GBC White Gloss Covers, Plain Front	81.088	7	27.3672
CA-2020-156951	10/1/2020	10/8/2020	Standard Class	EB-13840	Ellis Ballard	Corporate	United States	Seattle	Washington	West	OFF-PA-10004451	Office Supplies	Paper	Xerox 222	19.44	3	9.3312
CA-2020-156951	10/1/2020	10/8/2020	Standard Class	EB-13840	Ellis Ballard	Corporate	United States	Seattle	Washington	West	FUR-CH-10004997	Furniture	Chairs	Hon Every-Day Series Multi-Task Chairs	451.152	3	0
CA-2020-164826	12/28/2020	1/4/2019	Standard Class	JF-15415	Jennifer Ferguson	Consumer	United States	New York City	New York	East	OFF-LA-10001297	Office Supplies	Labels	Avery 473	72.45	7	34.776
CA-2020-164826	12/28/2020	1/4/2019	Standard Class	JF-15415	Jennifer Ferguson	Consumer	United States	New York City	New York	East	OFF-FA-10000585	Office Supplies	Fasteners	OIC Bulk Pack Metal Binder Clips	13.96	4	6.4216
CA-2020-164826	12/28/2020	1/4/2019	Standard Class	JF-15415	Jennifer Ferguson	Consumer	United States	New York City	New York	East	OFF-BI-10001922	Office Supplies	Binders	Storex Dura Pro Binders	33.264	7	11.2266
CA-2020-164826	12/28/2020	1/4/2019	Standard Class	JF-15415	Jennifer Ferguson	Consumer	United States	New York City	New York	East	TEC-PH-10000347	Technology	Phones	Cush Cases Heavy Duty Rugged Cover Case for Samsung Galaxy S5 - Purple	14.85	3	4.0095
CA-2019-127250	11/3/2019	11/7/2019	Standard Class	SF-20200	Sarah Foster	Consumer	United States	Marysville	Washington	West	OFF-AR-10003394	Office Supplies	Art	Newell 332	8.82	3	2.3814
CA-2020-118640	7/20/2020	7/26/2020	Standard Class	CS-11950	Carlos Soltero	Consumer	United States	Chicago	Illinois	Central	OFF-ST-10002974	Office Supplies	Storage	Trav-L-File Heavy-Duty Shuttle II, Black	69.712	2	8.714
CA-2020-118640	7/20/2020	7/26/2020	Standard Class	CS-11950	Carlos Soltero	Consumer	United States	Chicago	Illinois	Central	FUR-FU-10001475	Furniture	Furnishings	Contract Clock, 14", Brown	8.792	1	-5.7148
CA-2020-145233	12/1/2020	12/5/2020	Standard Class	DV-13465	Dianna Vittorini	Consumer	United States	Denver	Colorado	West	TEC-PH-10004977	Technology	Phones	GE 30524EE4	470.376	3	52.9173
CA-2020-145233	12/1/2020	12/5/2020	Standard Class	DV-13465	Dianna Vittorini	Consumer	United States	Denver	Colorado	West	TEC-PH-10000586	Technology	Phones	AT&T SB67148 SynJ	105.584	2	9.2386
CA-2020-145233	12/1/2020	12/5/2020	Standard Class	DV-13465	Dianna Vittorini	Consumer	United States	Denver	Colorado	West	OFF-AP-10000358	Office Supplies	Appliances	Fellowes Basic Home/Office Series Surge Protectors	31.152	3	3.5046
CA-2020-145233	12/1/2020	12/5/2020	Standard Class	DV-13465	Dianna Vittorini	Consumer	United States	Denver	Colorado	West	OFF-BI-10002764	Office Supplies	Binders	Recycled Pressboard Report Cover with Reinforced Top Hinge	6.783	7	-4.7481
CA-2020-145233	12/1/2020	12/5/2020	Standard Class	DV-13465	Dianna Vittorini	Consumer	United States	Denver	Colorado	West	TEC-PH-10001254	Technology	Phones	Jabra BIZ 2300 Duo QD Duo Corded�Headset	406.368	4	30.4776
US-2019-156986	3/20/2019	3/24/2019	Standard Class	ZC-21910	Zuschuss Carroll	Consumer	United States	Salem	Oregon	West	TEC-PH-10003800	Technology	Phones	i.Sound Portable Power - 8000 mAh	84.784	2	-20.1362
US-2019-156986	3/20/2019	3/24/2019	Standard Class	ZC-21910	Zuschuss Carroll	Consumer	United States	Salem	Oregon	West	OFF-PA-10002005	Office Supplies	Paper	Xerox 225	20.736	4	7.2576
US-2019-156986	3/20/2019	3/24/2019	Standard Class	ZC-21910	Zuschuss Carroll	Consumer	United States	Salem	Oregon	West	OFF-BI-10002498	Office Supplies	Binders	Clear Mylar Reinforcing Strips	16.821	3	-12.8961
US-2019-156986	3/20/2019	3/24/2019	Standard Class	ZC-21910	Zuschuss Carroll	Consumer	United States	Salem	Oregon	West	OFF-PA-10004101	Office Supplies	Paper	Xerox 1894	10.368	2	3.6288
CA-2019-120200	7/14/2019	7/16/2019	First Class	TP-21130	Theone Pippenger	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-SU-10004115	Office Supplies	Supplies	Acme Stainless Steel Office Snips	11.632	2	1.0178
US-2019-100720	7/16/2019	7/21/2019	Standard Class	CK-12205	Chloris Kastensmidt	Consumer	United States	Philadelphia	Pennsylvania	East	TEC-PH-10001425	Technology	Phones	Mophie Juice Pack Helium for iPhone	143.982	3	-28.7964
US-2019-100720	7/16/2019	7/21/2019	Standard Class	CK-12205	Chloris Kastensmidt	Consumer	United States	Philadelphia	Pennsylvania	East	TEC-PH-10003963	Technology	Phones	GE 2-Jack Phone Line Splitter	494.376	4	-115.3544
US-2019-100720	7/16/2019	7/21/2019	Standard Class	CK-12205	Chloris Kastensmidt	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-SU-10001574	Office Supplies	Supplies	Acme Value Line Scissors	5.84	2	0.73
CA-2019-161816	4/28/2019	5/1/2019	First Class	NB-18655	Nona Balk	Corporate	United States	Dallas	Texas	Central	TEC-PH-10003012	Technology	Phones	Nortel Meridian M3904 Professional Digital phone	369.576	3	41.5773
CA-2019-161816	4/28/2019	5/1/2019	First Class	NB-18655	Nona Balk	Corporate	United States	Dallas	Texas	Central	OFF-LA-10004345	Office Supplies	Labels	Avery 493	15.712	4	5.6956
CA-2019-121223	9/11/2019	9/13/2019	Second Class	GD-14590	Giulietta Dortch	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-PA-10001204	Office Supplies	Paper	Xerox 1972	8.448	2	2.64
CA-2019-121223	9/11/2019	9/13/2019	Second Class	GD-14590	Giulietta Dortch	Corporate	United States	Philadelphia	Pennsylvania	East	TEC-PH-10004667	Technology	Phones	Cisco 8x8 Inc. 6753i IP Business Phone System	728.946	9	-157.9383
CA-2020-138611	11/14/2020	11/17/2020	Second Class	CK-12595	Clytie Kelty	Consumer	United States	Grove City	Ohio	East	TEC-PH-10000011	Technology	Phones	PureGear Roll-On Screen Protector	119.94	10	15.992
CA-2020-138611	11/14/2020	11/17/2020	Second Class	CK-12595	Clytie Kelty	Consumer	United States	Grove City	Ohio	East	OFF-BI-10002949	Office Supplies	Binders	Prestige Round Ring Binders	3.648	2	-2.7968
CA-2020-117947	8/18/2020	8/23/2020	Second Class	NG-18355	Nat Gilpin	Corporate	United States	New York City	New York	East	FUR-FU-10003849	Furniture	Furnishings	DAX Metal Frame, Desktop, Stepped-Edge	40.48	2	15.7872
CA-2020-117947	8/18/2020	8/23/2020	Second Class	NG-18355	Nat Gilpin	Corporate	United States	New York City	New York	East	FUR-FU-10000010	Furniture	Furnishings	DAX Value U-Channel Document Frames, Easel Back	9.94	2	3.0814
CA-2020-117947	8/18/2020	8/23/2020	Second Class	NG-18355	Nat Gilpin	Corporate	United States	New York City	New York	East	OFF-BI-10002824	Office Supplies	Binders	Recycled Easel Ring Binders	107.424	9	33.57
CA-2020-117947	8/18/2020	8/23/2020	Second Class	NG-18355	Nat Gilpin	Corporate	United States	New York City	New York	East	TEC-PH-10002538	Technology	Phones	Grandstream GXP1160 VoIP phone	37.91	1	10.9939
CA-2020-117947	8/18/2020	8/23/2020	Second Class	NG-18355	Nat Gilpin	Corporate	United States	New York City	New York	East	FUR-FU-10000521	Furniture	Furnishings	Seth Thomas 14" Putty-Colored Wall Clock	88.02	3	27.2862
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2020-163020	9/15/2020	9/19/2020	Standard Class	MO-17800	Meg O'Connel	Home Office	United States	New York City	New York	East	FUR-FU-10000221	Furniture	Furnishings	Master Caster Door Stop, Brown	35.56	7	12.0904
CA-2020-153787	5/19/2020	5/23/2020	Standard Class	AT-10735	Annie Thurman	Consumer	United States	Seattle	Washington	West	OFF-AP-10001563	Office Supplies	Appliances	Belkin Premiere Surge Master II 8-outlet surge protector	97.16	2	28.1764
CA-2020-133431	12/17/2020	12/21/2020	Standard Class	LC-17140	Logan Currie	Consumer	United States	San Francisco	California	West	OFF-BI-10000605	Office Supplies	Binders	Acco Pressboard Covers with Storage Hooks, 9 1/2" x 11", Executive Red	15.24	5	5.1435
CA-2020-133431	12/17/2020	12/21/2020	Standard Class	LC-17140	Logan Currie	Consumer	United States	San Francisco	California	West	OFF-PA-10002615	Office Supplies	Paper	Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled	13.23	3	6.0858
US-2019-135720	12/11/2019	12/13/2019	Second Class	FM-14380	Fred McMath	Consumer	United States	Aurora	Colorado	West	OFF-ST-10001963	Office Supplies	Storage	Tennsco Regal Shelving Units	243.384	3	-51.7191
US-2019-135720	12/11/2019	12/13/2019	Second Class	FM-14380	Fred McMath	Consumer	United States	Aurora	Colorado	West	TEC-AC-10001267	Technology	Accessories	Imation�32GB Pocket Pro USB 3.0�Flash Drive�- 32 GB - Black - 1 P ...	119.8	5	29.95
US-2019-135720	12/11/2019	12/13/2019	Second Class	FM-14380	Fred McMath	Consumer	United States	Aurora	Colorado	West	TEC-PH-10002103	Technology	Phones	Jabra SPEAK 410	300.768	4	30.0768
CA-2020-144694	9/24/2020	9/26/2020	Second Class	BD-11605	Brian Dahlen	Consumer	United States	Miami	Florida	South	TEC-AC-10002857	Technology	Accessories	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 1/Pack	17.88	3	2.4585
CA-2020-144694	9/24/2020	9/26/2020	Second Class	BD-11605	Brian Dahlen	Consumer	United States	Miami	Florida	South	OFF-LA-10003930	Office Supplies	Labels	Dot Matrix Printer Tape Reel Labels, White, 5000/Box	235.944	3	85.5297
US-2019-123470	8/15/2019	8/21/2019	Standard Class	ME-17725	Max Engle	Consumer	United States	Aurora	Colorado	West	OFF-BI-10001989	Office Supplies	Binders	Premium Transparent Presentation Covers by GBC	18.882	3	-13.8468
US-2019-123470	8/15/2019	8/21/2019	Standard Class	ME-17725	Max Engle	Consumer	United States	Aurora	Colorado	West	OFF-AP-10003287	Office Supplies	Appliances	Tripp Lite TLP810NET Broadband Surge for Modem/Fax	122.328	3	12.2328
CA-2019-115917	5/20/2019	5/25/2019	Standard Class	RB-19465	Rick Bensley	Home Office	United States	Vallejo	California	West	FUR-FU-10000576	Furniture	Furnishings	Luxo Professional Fluorescent Magnifier Lamp with Clamp-Mount Base	1049.2	5	272.792
CA-2019-115917	5/20/2019	5/25/2019	Standard Class	RB-19465	Rick Bensley	Home Office	United States	Vallejo	California	West	OFF-BI-10004728	Office Supplies	Binders	Wilson Jones Turn Tabs Binder Tool for Ring Binders	15.424	4	5.0128
CA-2019-147067	12/18/2019	12/22/2019	Standard Class	JD-16150	Justin Deggeller	Corporate	United States	Minneapolis	Minnesota	Central	FUR-FU-10000732	Furniture	Furnishings	Eldon 200 Class Desk Accessories	18.84	3	6.0288
CA-2020-167913	7/30/2020	8/3/2020	Second Class	JL-15835	John Lee	Consumer	United States	Mission Viejo	California	West	OFF-ST-10000585	Office Supplies	Storage	Economy Rollaway Files	330.4	2	85.904
CA-2020-167913	7/30/2020	8/3/2020	Second Class	JL-15835	John Lee	Consumer	United States	Mission Viejo	California	West	OFF-LA-10002787	Office Supplies	Labels	Avery 480	26.25	7	12.6
CA-2020-106103	6/10/2020	6/15/2020	Standard Class	SC-20305	Sean Christensen	Consumer	United States	Rochester Hills	Michigan	Central	TEC-AC-10003832	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	132.52	4	54.3332
US-2020-127719	7/21/2020	7/25/2020	Standard Class	TW-21025	Tamara Willingham	Home Office	United States	Plainfield	New Jersey	East	OFF-PA-10001934	Office Supplies	Paper	Xerox 1993	6.48	1	3.1752
CA-2020-126221	12/30/2020	1/5/2019	Standard Class	CC-12430	Chuck Clark	Home Office	United States	Columbus	Indiana	Central	OFF-AP-10002457	Office Supplies	Appliances	Eureka The Boss Plus 12-Amp Hard Box Upright Vacuum, Red	209.3	2	56.511
CA-2019-103947	4/1/2019	4/8/2019	Standard Class	BB-10990	Barry Blumstein	Corporate	United States	Sierra Vista	Arizona	West	OFF-FA-10003112	Office Supplies	Fasteners	Staples	31.56	5	9.8625
CA-2019-103947	4/1/2019	4/8/2019	Standard Class	BB-10990	Barry Blumstein	Corporate	United States	Sierra Vista	Arizona	West	OFF-AP-10002350	Office Supplies	Appliances	Belkin F9H710-06 7 Outlet SurgeMaster Surge Protector	30.144	2	3.0144
CA-2019-160745	12/11/2019	12/16/2019	Second Class	AR-10825	Anthony Rawles	Corporate	United States	Vancouver	Washington	West	FUR-FU-10001935	Furniture	Furnishings	3M Hangers With Command Adhesive	14.8	4	6.068
CA-2019-160745	12/11/2019	12/16/2019	Second Class	AR-10825	Anthony Rawles	Corporate	United States	Vancouver	Washington	West	TEC-PH-10003273	Technology	Phones	AT&T TR1909W	302.376	3	22.6782
CA-2019-160745	12/11/2019	12/16/2019	Second Class	AR-10825	Anthony Rawles	Corporate	United States	Vancouver	Washington	West	TEC-AC-10001142	Technology	Accessories	First Data FD10 PIN Pad	316	4	31.6
CA-2019-132661	10/23/2019	10/29/2019	Standard Class	SR-20740	Steven Roelle	Home Office	United States	New York City	New York	East	OFF-PA-10000482	Office Supplies	Paper	Snap-A-Way Black Print Carbonless Ruled Speed Letter, Triplicate	379.4	10	178.318
CA-2020-140844	6/19/2020	6/23/2020	Standard Class	AR-10405	Allen Rosenblatt	Corporate	United States	New York City	New York	East	OFF-PA-10003892	Office Supplies	Paper	Xerox 1943	97.82	2	45.9754
CA-2020-140844	6/19/2020	6/23/2020	Standard Class	AR-10405	Allen Rosenblatt	Corporate	United States	New York City	New York	East	TEC-AC-10001101	Technology	Accessories	Sony 16GB Class 10 Micro SDHC R40 Memory Card	103.12	8	10.312
CA-2019-137239	8/22/2019	8/28/2019	Standard Class	CR-12730	Craig Reiter	Consumer	United States	Columbus	Ohio	East	OFF-AP-10002439	Office Supplies	Appliances	Tripp Lite Isotel 8 Ultra 8 Outlet Metal Surge	113.552	2	8.5164
CA-2019-137239	8/22/2019	8/28/2019	Standard Class	CR-12730	Craig Reiter	Consumer	United States	Columbus	Ohio	East	OFF-BI-10002827	Office Supplies	Binders	Avery Durable Poly Binders	3.318	2	-2.6544
CA-2019-137239	8/22/2019	8/28/2019	Standard Class	CR-12730	Craig Reiter	Consumer	United States	Columbus	Ohio	East	OFF-EN-10002230	Office Supplies	Envelopes	Airmail Envelopes	134.288	2	45.3222
US-2019-156097	9/19/2019	9/19/2019	Same Day	EH-14125	Eugene Hildebrand	Home Office	United States	Aurora	Illinois	Central	FUR-CH-10001215	Furniture	Chairs	Global Troy Executive Leather Low-Back Tilter	701.372	2	-50.098
US-2019-156097	9/19/2019	9/19/2019	Same Day	EH-14125	Eugene Hildebrand	Home Office	United States	Aurora	Illinois	Central	OFF-BI-10004654	Office Supplies	Binders	Avery Binding System Hidden Tab Executive Style Index Sets	2.308	2	-3.462
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2019-123666	3/26/2019	3/30/2019	Standard Class	SP-20545	Sibella Parks	Corporate	United States	New York City	New York	East	OFF-ST-10001522	Office Supplies	Storage	Gould Plastics 18-Pocket Panel Bin, 34w x 5-1/4d x 20-1/2h	459.95	5	18.398
CA-2019-143308	11/4/2019	11/4/2019	Same Day	RC-19825	Roy Collins	Consumer	United States	Louisville	Kentucky	South	OFF-FA-10000621	Office Supplies	Fasteners	OIC Colored Binder Clips, Assorted Sizes	10.74	3	5.2626
CA-2020-132682	6/8/2020	6/10/2020	Second Class	TH-21235	Tiffany House	Corporate	United States	Dallas	Texas	Central	OFF-SU-10004231	Office Supplies	Supplies	Acme Tagit Stainless Steel Antibacterial Scissors	23.76	3	2.079
CA-2020-132682	6/8/2020	6/10/2020	Second Class	TH-21235	Tiffany House	Corporate	United States	Dallas	Texas	Central	OFF-PA-10000474	Office Supplies	Paper	Easy-staple paper	85.056	3	28.7064
CA-2020-132682	6/8/2020	6/10/2020	Second Class	TH-21235	Tiffany House	Corporate	United States	Dallas	Texas	Central	TEC-PH-10004042	Technology	Phones	ClearOne Communications CHAT 70 OC�Speaker Phone	381.576	3	28.6182
US-2020-106663	6/9/2020	6/13/2020	Standard Class	MO-17800	Meg O'Connel	Home Office	United States	Chicago	Illinois	Central	FUR-FU-10002759	Furniture	Furnishings	12-1/2 Diameter Round Wall Clock	23.976	3	-14.3856
US-2020-106663	6/9/2020	6/13/2020	Standard Class	MO-17800	Meg O'Connel	Home Office	United States	Chicago	Illinois	Central	FUR-TA-10000688	Furniture	Tables	Chromcraft Bull-Nose Wood Round Conference Table Top, Wood Base	108.925	1	-71.8905
US-2020-106663	6/9/2020	6/13/2020	Standard Class	MO-17800	Meg O'Connel	Home Office	United States	Chicago	Illinois	Central	OFF-PA-10002377	Office Supplies	Paper	Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages	36.352	8	11.36
CA-2020-111178	6/15/2020	6/22/2020	Standard Class	TD-20995	Tamara Dahlen	Consumer	United States	Quincy	Illinois	Central	OFF-AR-10001954	Office Supplies	Art	Newell 331	19.56	5	1.7115
CA-2020-130351	12/5/2020	12/8/2020	First Class	RB-19570	Rob Beeghly	Consumer	United States	Columbus	Indiana	Central	OFF-AP-10004532	Office Supplies	Appliances	Kensington 6 Outlet Guardian Standard Surge Protector	61.44	3	16.5888
CA-2020-130351	12/5/2020	12/8/2020	First Class	RB-19570	Rob Beeghly	Consumer	United States	Columbus	Indiana	Central	OFF-PA-10002137	Office Supplies	Paper	Southworth 100% R�sum� Paper, 24lb.	38.9	5	17.505
CA-2020-130351	12/5/2020	12/8/2020	First Class	RB-19570	Rob Beeghly	Consumer	United States	Columbus	Indiana	Central	TEC-AC-10003832	Technology	Accessories	Imation�16GB Mini TravelDrive USB 2.0�Flash Drive	99.39	3	40.7499
US-2020-119438	3/18/2020	3/23/2020	Standard Class	CD-11980	Carol Darley	Consumer	United States	Tyler	Texas	Central	OFF-AP-10000804	Office Supplies	Appliances	Hoover Portapower Portable Vacuum	2.688	3	-7.392
US-2020-119438	3/18/2020	3/23/2020	Standard Class	CD-11980	Carol Darley	Consumer	United States	Tyler	Texas	Central	TEC-AC-10003614	Technology	Accessories	Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 10/Pack	27.816	3	4.5201
US-2020-119438	3/18/2020	3/23/2020	Standard Class	CD-11980	Carol Darley	Consumer	United States	Tyler	Texas	Central	FUR-FU-10003553	Furniture	Furnishings	Howard Miller 13-1/2" Diameter Rosebrook Wall Clock	82.524	3	-41.262
US-2020-119438	3/18/2020	3/23/2020	Standard Class	CD-11980	Carol Darley	Consumer	United States	Tyler	Texas	Central	OFF-BI-10004632	Office Supplies	Binders	Ibico Hi-Tech Manual Binding System	182.994	3	-320.2395
CA-2019-164511	11/19/2019	11/24/2019	Standard Class	DJ-13630	Doug Jacobs	Consumer	United States	New York City	New York	East	OFF-BI-10003305	Office Supplies	Binders	Avery Hanging File Binders	14.352	3	4.6644
CA-2019-164511	11/19/2019	11/24/2019	Standard Class	DJ-13630	Doug Jacobs	Consumer	United States	New York City	New York	East	OFF-ST-10002583	Office Supplies	Storage	Fellowes Neat Ideas Storage Cubes	64.96	2	2.5984
CA-2019-164511	11/19/2019	11/24/2019	Standard Class	DJ-13630	Doug Jacobs	Consumer	United States	New York City	New York	East	OFF-ST-10004507	Office Supplies	Storage	Advantus Rolling Storage Box	68.6	4	18.522
US-2020-168116	11/4/2020	11/4/2020	Same Day	GT-14635	Grant Thornton	Corporate	United States	Burlington	North Carolina	South	TEC-MA-10004125	Technology	Machines	Cubify CubeX 3D Printer Triple Head Print	7999.98	4	-3839.9904
US-2020-168116	11/4/2020	11/4/2020	Same Day	GT-14635	Grant Thornton	Corporate	United States	Burlington	North Carolina	South	OFF-AP-10002457	Office Supplies	Appliances	Eureka The Boss Plus 12-Amp Hard Box Upright Vacuum, Red	167.44	2	14.651
CA-2020-161480	12/25/2020	12/29/2020	Standard Class	RA-19285	Ralph Arnett	Consumer	United States	New York City	New York	East	FUR-BO-10004015	Furniture	Bookcases	Bush Andora Bookcase, Maple/Graphite Gray Finish	191.984	2	4.7996
CA-2020-114552	9/2/2020	9/8/2020	Standard Class	Dl-13600	Dorris liebe	Corporate	United States	Cleveland	Ohio	East	FUR-FU-10002960	Furniture	Furnishings	Eldon 200 Class Desk Accessories, Burgundy	15.072	3	4.1448
CA-2019-163755	11/4/2019	11/8/2019	Second Class	AS-10285	Alejandro Savely	Corporate	United States	Seattle	Washington	West	FUR-FU-10003394	Furniture	Furnishings	Tenex "The Solids" Textured Chair Mats	209.88	3	35.6796
CA-2020-146136	9/3/2020	9/7/2020	Standard Class	AP-10915	Arthur Prichep	Consumer	United States	Palm Coast	Florida	South	OFF-EN-10001219	Office Supplies	Envelopes	#10- 4 1/8" x 9 1/2" Security-Tint Envelopes	24.448	4	8.8624
US-2020-100048	5/19/2020	5/24/2020	Standard Class	RS-19765	Roland Schwarz	Corporate	United States	Mount Vernon	New York	East	OFF-AP-10001154	Office Supplies	Appliances	Bionaire Personal Warm Mist Humidifier/Vaporizer	281.34	6	109.7226
US-2020-100048	5/19/2020	5/24/2020	Standard Class	RS-19765	Roland Schwarz	Corporate	United States	Mount Vernon	New York	East	TEC-PH-10003012	Technology	Phones	Nortel Meridian M3904 Professional Digital phone	307.98	2	89.3142
US-2020-100048	5/19/2020	5/24/2020	Standard Class	RS-19765	Roland Schwarz	Corporate	United States	Mount Vernon	New York	East	TEC-AC-10001606	Technology	Accessories	Logitech Wireless Performance Mouse MX for PC and Mac	299.97	3	113.9886
CA-2020-108910	9/24/2020	9/29/2020	Standard Class	KC-16540	Kelly Collister	Consumer	United States	Newark	Ohio	East	FUR-FU-10002253	Furniture	Furnishings	Howard Miller 13" Diameter Pewter Finish Round Wall Clock	103.056	3	24.4758
CA-2019-112942	2/13/2019	2/18/2019	Standard Class	RD-19810	Ross DeVincentis	Home Office	United States	Los Angeles	California	West	OFF-PA-10004092	Office Supplies	Paper	Tops Green Bar Computer Printout Paper	146.82	3	73.41
CA-2019-142335	12/15/2019	12/19/2019	Standard Class	MP-17965	Michael Paige	Corporate	United States	Detroit	Michigan	Central	FUR-TA-10000198	Furniture	Tables	Chromcraft Bull-Nose Wood Oval Conference Tables & Bases	1652.94	3	231.4116
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2019-142335	12/15/2019	12/19/2019	Standard Class	MP-17965	Michael Paige	Corporate	United States	Detroit	Michigan	Central	OFF-ST-10000036	Office Supplies	Storage	Recycled Data-Pak for Archival Bound Computer Printouts, 12-1/2 x 12-1/2 x 16	296.37	3	80.0199
CA-2019-114713	7/7/2019	7/12/2019	Standard Class	SC-20695	Steve Chapman	Corporate	United States	Hialeah	Florida	South	OFF-SU-10004664	Office Supplies	Supplies	Acme Softgrip Scissors	45.584	7	5.1282
CA-2020-144113	9/16/2020	9/20/2020	Standard Class	JF-15355	Jay Fein	Consumer	United States	Austin	Texas	Central	OFF-EN-10001141	Office Supplies	Envelopes	Manila Recycled Extra-Heavyweight Clasp Envelopes, 6" x 9"	17.568	2	6.3684
CA-2020-144113	9/16/2020	9/20/2020	Standard Class	JF-15355	Jay Fein	Consumer	United States	Austin	Texas	Central	TEC-PH-10002170	Technology	Phones	ClearSounds CSC500 Amplified Spirit Phone Corded phone	55.992	1	5.5992
US-2019-150861	12/3/2019	12/6/2019	First Class	EG-13900	Emily Grady	Consumer	United States	Oceanside	New York	East	OFF-PA-10001954	Office Supplies	Paper	Xerox 1964	182.72	8	84.0512
US-2019-150861	12/3/2019	12/6/2019	First Class	EG-13900	Emily Grady	Consumer	United States	Oceanside	New York	East	FUR-TA-10002228	Furniture	Tables	Bevis Traditional Conference Table Top, Plinth Base	400.032	2	-153.3456
US-2019-150861	12/3/2019	12/6/2019	First Class	EG-13900	Emily Grady	Consumer	United States	Oceanside	New York	East	OFF-ST-10004634	Office Supplies	Storage	Personal Folder Holder, Ebony	33.63	3	10.089
US-2019-150861	12/3/2019	12/6/2019	First Class	EG-13900	Emily Grady	Consumer	United States	Oceanside	New York	East	FUR-CH-10002965	Furniture	Chairs	Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black	542.646	3	102.4998
US-2019-150861	12/3/2019	12/6/2019	First Class	EG-13900	Emily Grady	Consumer	United States	Oceanside	New York	East	OFF-LA-10001317	Office Supplies	Labels	Avery 520	6.3	2	3.024
CA-2020-131954	1/21/2020	1/25/2020	Standard Class	DS-13030	Darrin Sayre	Home Office	United States	Seattle	Washington	West	OFF-ST-10000736	Office Supplies	Storage	Carina Double Wide Media Storage Towers in Natural & Black	242.94	3	9.7176
CA-2020-131954	1/21/2020	1/25/2020	Standard Class	DS-13030	Darrin Sayre	Home Office	United States	Seattle	Washington	West	TEC-AC-10003610	Technology	Accessories	Logitech�Illuminated - Keyboard	179.97	3	86.3856
CA-2020-131954	1/21/2020	1/25/2020	Standard Class	DS-13030	Darrin Sayre	Home Office	United States	Seattle	Washington	West	OFF-BI-10003982	Office Supplies	Binders	Wilson Jones Century Plastic Molded Ring Binders	99.696	6	33.6474
CA-2020-131954	1/21/2020	1/25/2020	Standard Class	DS-13030	Darrin Sayre	Home Office	United States	Seattle	Washington	West	OFF-BI-10003291	Office Supplies	Binders	Wilson Jones Leather-Like Binders with DublLock Round Rings	27.936	4	9.4284
CA-2020-131954	1/21/2020	1/25/2020	Standard Class	DS-13030	Darrin Sayre	Home Office	United States	Seattle	Washington	West	FUR-BO-10001619	Furniture	Bookcases	O'Sullivan Cherrywood Estates Traditional Bookcase	84.98	1	18.6956
CA-2020-131954	1/21/2020	1/25/2020	Standard Class	DS-13030	Darrin Sayre	Home Office	United States	Seattle	Washington	West	OFF-BI-10000138	Office Supplies	Binders	Acco Translucent Poly Ring Binders	18.72	5	6.552
US-2019-146710	8/27/2019	9/1/2019	Standard Class	SS-20875	Sung Shariari	Consumer	United States	Dallas	Texas	Central	OFF-SU-10004498	Office Supplies	Supplies	Martin-Yale Premier Letter Opener	51.52	5	-10.948
US-2019-146710	8/27/2019	9/1/2019	Standard Class	SS-20875	Sung Shariari	Consumer	United States	Dallas	Texas	Central	OFF-PA-10002615	Office Supplies	Paper	Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled	3.528	1	1.1466
US-2019-146710	8/27/2019	9/1/2019	Standard Class	SS-20875	Sung Shariari	Consumer	United States	Dallas	Texas	Central	OFF-PA-10004971	Office Supplies	Paper	Xerox 196	4.624	1	1.6762
US-2019-146710	8/27/2019	9/1/2019	Standard Class	SS-20875	Sung Shariari	Consumer	United States	Dallas	Texas	Central	OFF-SU-10004261	Office Supplies	Supplies	Fiskars 8" Scissors, 2/Pack	55.168	4	6.2064
CA-2019-150889	3/20/2019	3/22/2019	Second Class	PB-19105	Peter B�hler	Consumer	United States	Evanston	Illinois	Central	TEC-PH-10000004	Technology	Phones	Belkin iPhone and iPad Lightning Cable	11.992	1	0.8994
CA-2020-126074	10/2/2020	10/6/2020	Standard Class	RF-19735	Roland Fjeld	Consumer	United States	Trenton	Michigan	Central	OFF-BI-10003638	Office Supplies	Binders	GBC Durable Plastic Covers	58.05	3	26.703
CA-2020-126074	10/2/2020	10/6/2020	Standard Class	RF-19735	Roland Fjeld	Consumer	United States	Trenton	Michigan	Central	FUR-FU-10003577	Furniture	Furnishings	Nu-Dell Leatherette Frames	157.74	11	56.7864
CA-2020-126074	10/2/2020	10/6/2020	Standard Class	RF-19735	Roland Fjeld	Consumer	United States	Trenton	Michigan	Central	OFF-AR-10003478	Office Supplies	Art	Avery Hi-Liter EverBold Pen Style Fluorescent Highlighters, 4/Pack	56.98	7	22.792
CA-2020-126074	10/2/2020	10/6/2020	Standard Class	RF-19735	Roland Fjeld	Consumer	United States	Trenton	Michigan	Central	OFF-BI-10000546	Office Supplies	Binders	Avery Durable Binders	2.88	1	1.4112
CA-2019-110499	4/7/2019	4/9/2019	First Class	YC-21895	Yoseph Carroll	Corporate	United States	San Francisco	California	West	TEC-CO-10002095	Technology	Copiers	Hewlett Packard 610 Color Digital Copier / Printer	1199.976	3	374.9925
CA-2019-140928	9/18/2019	9/22/2019	Standard Class	NB-18655	Nona Balk	Corporate	United States	Jacksonville	Florida	South	FUR-TA-10001095	Furniture	Tables	Chromcraft Round Conference Tables	383.438	4	-167.3184
CA-2020-117240	7/23/2020	7/28/2020	Standard Class	CP-12340	Christine Phan	Corporate	United States	New York City	New York	East	OFF-BI-10000848	Office Supplies	Binders	Angle-D Ring Binders	13.128	3	4.2666
CA-2020-133333	9/18/2020	9/22/2020	Standard Class	BF-11020	Barry Franz�sisch	Corporate	United States	Green Bay	Wisconsin	Central	OFF-PA-10002377	Office Supplies	Paper	Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages	22.72	4	10.224
CA-2020-126046	11/3/2020	11/7/2020	Standard Class	JC-16105	Julie Creighton	Corporate	United States	Atlanta	Georgia	South	OFF-LA-10004484	Office Supplies	Labels	Avery 476	12.39	3	5.6994
CA-2019-157245	5/19/2019	5/24/2019	Standard Class	LE-16810	Laurel Elliston	Consumer	United States	Arlington	Virginia	South	FUR-CH-10003746	Furniture	Chairs	Hon 4070 Series Pagoda Round Back Stacking Chairs	641.96	2	179.7488
CA-2020-104220	1/30/2020	2/5/2020	Standard Class	BV-11245	Benjamin Venier	Corporate	United States	Des Moines	Iowa	Central	OFF-BI-10001036	Office Supplies	Binders	Cardinal EasyOpen D-Ring Binders	18.28	2	9.14
CA-2020-104220	1/30/2020	2/5/2020	Standard Class	BV-11245	Benjamin Venier	Corporate	United States	Des Moines	Iowa	Central	TEC-PH-10004614	Technology	Phones	AT&T 841000 Phone	207	3	51.75
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
CA-2020-104220	1/30/2020	2/5/2020	Standard Class	BV-11245	Benjamin Venier	Corporate	United States	Des Moines	Iowa	Central	OFF-BI-10000301	Office Supplies	Binders	GBC Instant Report Kit	32.35	5	16.175
CA-2020-104220	1/30/2020	2/5/2020	Standard Class	BV-11245	Benjamin Venier	Corporate	United States	Des Moines	Iowa	Central	OFF-BI-10003910	Office Supplies	Binders	DXL Angle-View Binders with Locking Rings by Samsill	7.71	1	3.4695
CA-2020-104220	1/30/2020	2/5/2020	Standard Class	BV-11245	Benjamin Venier	Corporate	United States	Des Moines	Iowa	Central	OFF-AR-10004648	Office Supplies	Art	Boston 19500 Mighty Mite Electric Pencil Sharpener	40.3	2	10.881
CA-2020-104220	1/30/2020	2/5/2020	Standard Class	BV-11245	Benjamin Venier	Corporate	United States	Des Moines	Iowa	Central	FUR-FU-10002597	Furniture	Furnishings	C-Line Magnetic Cubicle Keepers, Clear Polypropylene	34.58	7	14.5236
CA-2020-129567	3/17/2020	3/21/2020	Second Class	CL-12565	Clay Ludtke	Consumer	United States	Lancaster	California	West	OFF-BI-10000014	Office Supplies	Binders	Heavy-Duty E-Z-D Binders	17.456	2	5.8914
CA-2019-105256	5/20/2019	5/20/2019	Same Day	JK-15730	Joe Kamberova	Consumer	United States	Asheville	North Carolina	South	TEC-PH-10001530	Technology	Phones	Cisco Unified IP Phone 7945G VoIP phone	1363.96	5	85.2475
CA-2020-151428	9/21/2020	9/26/2020	Standard Class	RH-19495	Rick Hansen	Consumer	United States	Rochester	Minnesota	Central	OFF-BI-10000546	Office Supplies	Binders	Avery Durable Binders	20.16	7	9.8784
CA-2020-105809	2/20/2020	2/23/2020	First Class	HW-14935	Helen Wasserman	Corporate	United States	San Diego	California	West	FUR-FU-10004090	Furniture	Furnishings	Executive Impressions 14" Contract Wall Clock	22.23	1	7.3359
CA-2020-105809	2/20/2020	2/23/2020	First Class	HW-14935	Helen Wasserman	Corporate	United States	San Diego	California	West	TEC-PH-10001580	Technology	Phones	Logitech Mobile Speakerphone P710e -�speaker phone	215.968	2	18.8972
CA-2019-136133	8/18/2019	8/23/2019	Second Class	HW-14935	Helen Wasserman	Corporate	United States	New York City	New York	East	OFF-AP-10000576	Office Supplies	Appliances	Belkin 7 Outlet SurgeMaster II	355.32	9	99.4896
CA-2019-115504	3/12/2019	3/17/2019	Standard Class	MC-18130	Mike Caudle	Corporate	United States	Monroe	Louisiana	South	OFF-PA-10003953	Office Supplies	Paper	Xerox 218	12.96	2	6.2208
CA-2020-135783	4/22/2020	4/24/2020	First Class	GM-14440	Gary McGarr	Consumer	United States	San Francisco	California	West	FUR-FU-10000794	Furniture	Furnishings	Eldon Stackable Tray, Side-Load, Legal, Smoke	18.28	2	6.2152
CA-2020-143686	5/14/2020	5/14/2020	Same Day	PJ-19015	Pauline Johnson	Consumer	United States	Santa Ana	California	West	FUR-FU-10000794	Furniture	Furnishings	Eldon Stackable Tray, Side-Load, Legal, Smoke	18.28	2	6.2152
CA-2020-143686	5/14/2020	5/14/2020	Same Day	PJ-19015	Pauline Johnson	Consumer	United States	Santa Ana	California	West	TEC-AC-10001838	Technology	Accessories	Razer Tiamat Over Ear 7.1 Surround Sound PC Gaming Headset	1399.93	7	601.9699
CA-2019-149370	9/15/2019	9/19/2019	Standard Class	DB-13210	Dean Braden	Consumer	United States	Philadelphia	Pennsylvania	East	OFF-PA-10003651	Office Supplies	Paper	Xerox 1968	5.344	1	1.8704
CA-2020-101434	6/20/2020	6/27/2020	Standard Class	TR-21325	Toby Ritter	Consumer	United States	Belleville	New Jersey	East	TEC-AC-10002402	Technology	Accessories	Razer Kraken PRO Over Ear PC and Music Headset	239.97	3	71.991
CA-2020-101434	6/20/2020	6/27/2020	Standard Class	TR-21325	Toby Ritter	Consumer	United States	Belleville	New Jersey	East	OFF-LA-10003223	Office Supplies	Labels	Avery 508	9.82	2	4.8118
CA-2020-126956	8/21/2020	8/28/2020	Standard Class	GT-14710	Greg Tran	Consumer	United States	Lakeville	Minnesota	Central	OFF-FA-10002280	Office Supplies	Fasteners	Advantus Plastic Paper Clips	35	7	16.8
CA-2020-126956	8/21/2020	8/28/2020	Standard Class	GT-14710	Greg Tran	Consumer	United States	Lakeville	Minnesota	Central	OFF-SU-10000381	Office Supplies	Supplies	Acme Forged Steel Scissors with Black Enamel Handles	37.24	4	10.7996
CA-2020-126956	8/21/2020	8/28/2020	Standard Class	GT-14710	Greg Tran	Consumer	United States	Lakeville	Minnesota	Central	OFF-EN-10004459	Office Supplies	Envelopes	Security-Tint Envelopes	15.28	2	7.4872
CA-2020-129462	6/16/2020	6/21/2020	Second Class	JE-15745	Joel Eaton	Consumer	United States	Florence	Kentucky	South	FUR-CH-10000665	Furniture	Chairs	Global Airflow Leather Mesh Back Chair, Black	301.96	2	90.588
CA-2020-129462	6/16/2020	6/21/2020	Second Class	JE-15745	Joel Eaton	Consumer	United States	Florence	Kentucky	South	OFF-AP-10003884	Office Supplies	Appliances	Fellowes Smart Surge Ten-Outlet Protector, Platinum	180.66	3	50.5848
CA-2020-129462	6/16/2020	6/21/2020	Second Class	JE-15745	Joel Eaton	Consumer	United States	Florence	Kentucky	South	TEC-PH-10001557	Technology	Phones	Pyle PMP37LED	191.98	2	51.8346
CA-2020-129462	6/16/2020	6/21/2020	Second Class	JE-15745	Joel Eaton	Consumer	United States	Florence	Kentucky	South	TEC-PH-10002085	Technology	Phones	Clarity 53712	65.99	1	17.1574
CA-2019-165316	7/23/2019	7/27/2019	Standard Class	JB-15400	Jennifer Braxton	Corporate	United States	Tampa	Florida	South	OFF-AR-10002956	Office Supplies	Art	Boston 16801 Nautilus Battery Pencil Sharpener	35.216	2	2.6412
CA-2019-165316	7/23/2019	7/27/2019	Standard Class	JB-15400	Jennifer Braxton	Corporate	United States	Tampa	Florida	South	OFF-AP-10003266	Office Supplies	Appliances	Holmes Replacement Filter for HEPA Air Cleaner, Large Room	23.696	2	6.5164
CA-2019-165316	7/23/2019	7/27/2019	Standard Class	JB-15400	Jennifer Braxton	Corporate	United States	Tampa	Florida	South	TEC-MA-10004002	Technology	Machines	Zebra GX420t Direct Thermal/Thermal Transfer Printer	265.475	1	-111.4995
US-2020-156083	11/4/2020	11/11/2020	Standard Class	JL-15175	James Lanier	Home Office	United States	Columbia	Tennessee	South	OFF-PA-10001560	Office Supplies	Paper	Adams Telephone Message Books, 5 1/4? x 11?	9.664	2	3.2616
US-2019-137547	3/7/2019	3/12/2019	Standard Class	EB-13705	Ed Braxton	Corporate	United States	Fort Worth	Texas	Central	TEC-PH-10002365	Technology	Phones	Belkin Grip Candy Sheer Case / Cover for iPhone 5 and 5S	21.072	3	1.5804
CA-2019-161669	11/7/2019	11/9/2019	First Class	EM-14095	Eudokia Martin	Corporate	United States	Los Angeles	California	West	OFF-BI-10001294	Office Supplies	Binders	Fellowes Binding Cases	37.44	4	11.7
CA-2019-161669	11/7/2019	11/9/2019	First Class	EM-14095	Eudokia Martin	Corporate	United States	Los Angeles	California	West	OFF-BI-10001636	Office Supplies	Binders	Ibico Plastic and Wire Spiral Binding Combs	26.976	4	8.7672
CA-2019-161669	11/7/2019	11/9/2019	First Class	EM-14095	Eudokia Martin	Corporate	United States	Los Angeles	California	West	OFF-SU-10002503	Office Supplies	Supplies	Acme Preferred Stainless Steel Scissors	11.36	2	3.2944
CA-2019-161669	11/7/2019	11/9/2019	First Class	EM-14095	Eudokia Martin	Corporate	United States	Los Angeles	California	West	OFF-LA-10004093	Office Supplies	Labels	Avery 486	14.62	2	6.8714
CA-2020-107503	1/1/2020	1/6/2020	Standard Class	GA-14725	Guy Armstrong	Consumer	United States	Lorain	Ohio	East	FUR-FU-10003878	Furniture	Furnishings	Linden 10" Round Wall Clock, Black	48.896	4	8.5568
CA-2019-152534	6/20/2019	6/25/2019	Second Class	DP-13105	Dave Poirier	Corporate	United States	Salinas	California	West	OFF-AR-10002335	Office Supplies	Art	DIXON Oriole Pencils	5.16	2	1.3416
CA-2019-152534	6/20/2019	6/25/2019	Second Class	DP-13105	Dave Poirier	Corporate	United States	Salinas	California	West	OFF-PA-10001870	Office Supplies	Paper	Xerox 202	38.88	6	18.6624
CA-2019-113747	5/28/2019	6/4/2019	Standard Class	VD-21670	Valerie Dominguez	Consumer	United States	Jackson	Mississippi	South	OFF-AR-10003373	Office Supplies	Art	Boston School Pro Electric Pencil Sharpener, 1670	185.88	6	50.1876
CA-2019-123274	2/19/2019	2/24/2019	Standard Class	GT-14710	Greg Tran	Consumer	United States	New York City	New York	East	FUR-FU-10004090	Furniture	Furnishings	Executive Impressions 14" Contract Wall Clock	44.46	2	14.6718
CA-2019-123274	2/19/2019	2/24/2019	Standard Class	GT-14710	Greg Tran	Consumer	United States	New York City	New York	East	OFF-ST-10000736	Office Supplies	Storage	Carina Double Wide Media Storage Towers in Natural & Black	242.94	3	9.7176
CA-2020-161984	4/10/2020	4/15/2020	Standard Class	SJ-20125	Sanjit Jacobs	Home Office	United States	New Brunswick	New Jersey	East	OFF-PA-10004569	Office Supplies	Paper	Wirebound Message Books, Two 4 1/4" x 5" Forms per Page	7.61	1	3.5767
CA-2020-161984	4/10/2020	4/15/2020	Standard Class	SJ-20125	Sanjit Jacobs	Home Office	United States	New Brunswick	New Jersey	East	OFF-FA-10000624	Office Supplies	Fasteners	OIC Binder Clips	7.16	2	3.58
CA-2019-134474	1/5/2019	1/7/2019	Second Class	AJ-10795	Anthony Johnson	Corporate	United States	Jacksonville	Florida	South	TEC-AC-10001714	Technology	Accessories	Logitech�MX Performance Wireless Mouse	191.472	6	40.6878
CA-2019-134474	1/5/2019	1/7/2019	Second Class	AJ-10795	Anthony Johnson	Corporate	United States	Jacksonville	Florida	South	OFF-AR-10003958	Office Supplies	Art	Newell 337	5.248	2	0.5904
CA-2019-134474	1/5/2019	1/7/2019	Second Class	AJ-10795	Anthony Johnson	Corporate	United States	Jacksonville	Florida	South	TEC-PH-10002923	Technology	Phones	Logitech B530 USB�Headset�-�headset�- Full size, Binaural	59.184	2	5.1786
CA-2019-134362	9/29/2019	10/2/2019	First Class	LS-16945	Linda Southworth	Corporate	United States	Philadelphia	Pennsylvania	East	OFF-LA-10004853	Office Supplies	Labels	Avery 483	15.936	4	5.1792
CA-2019-158099	9/3/2019	9/5/2019	First Class	PK-18910	Paul Knutson	Home Office	United States	Philadelphia	Pennsylvania	East	OFF-BI-10000545	Office Supplies	Binders	GBC Ibimaster 500 Manual ProClick Binding System	1141.47	5	-760.98
CA-2019-158099	9/3/2019	9/5/2019	First Class	PK-18910	Paul Knutson	Home Office	United States	Philadelphia	Pennsylvania	East	TEC-PH-10002496	Technology	Phones	Cisco SPA301	280.782	3	-46.797
CA-2020-114636	8/25/2020	8/29/2020	Standard Class	GA-14725	Guy Armstrong	Consumer	United States	Charlotte	North Carolina	South	OFF-PA-10001790	Office Supplies	Paper	Xerox 1910	192.16	5	67.256
CA-2019-116736	1/17/2019	1/21/2019	Standard Class	CC-12430	Chuck Clark	Home Office	United States	Concord	New Hampshire	East	FUR-FU-10004017	Furniture	Furnishings	Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39" x 49"	322.59	3	64.518
CA-2019-116736	1/17/2019	1/21/2019	Standard Class	CC-12430	Chuck Clark	Home Office	United States	Concord	New Hampshire	East	TEC-AC-10003628	Technology	Accessories	Logitech 910-002974 M325 Wireless Mouse for Web Scrolling	29.99	1	13.1956
CA-2019-116736	1/17/2019	1/21/2019	Standard Class	CC-12430	Chuck Clark	Home Office	United States	Concord	New Hampshire	East	TEC-AC-10002049	Technology	Accessories	Logitech G19 Programmable Gaming Keyboard	371.97	3	66.9546
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Name: categories_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_categoryid_seq', 4, true);


--
-- Name: cities_cityid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_cityid_seq', 129, true);


--
-- Name: countries_countryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_countryid_seq', 1, true);


--
-- Name: regions_regionid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_regionid_seq', 5, true);


--
-- Name: segments_segmentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.segments_segmentid_seq', 4, true);


--
-- Name: shipments_shipmentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shipments_shipmentid_seq', 503, true);


--
-- Name: states_stateid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.states_stateid_seq', 37, true);


--
-- Name: subcategories_subcategoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subcategories_subcategoryid_seq', 18, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (categoryid);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (cityid);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (countryid);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customerid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (productid);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (regionid);


--
-- Name: segments segments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segments
    ADD CONSTRAINT segments_pkey PRIMARY KEY (segmentid);


--
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (shipmentid);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (stateid);


--
-- Name: subcategories subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT subcategories_pkey PRIMARY KEY (subcategoryid);


--
-- Name: cities cities_stateid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_stateid_fkey FOREIGN KEY (stateid) REFERENCES public.states(stateid);


--
-- Name: customers customers_cityid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_cityid_fkey FOREIGN KEY (cityid) REFERENCES public.cities(cityid);


--
-- Name: customers customers_countryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_countryid_fkey FOREIGN KEY (countryid) REFERENCES public.countries(countryid);


--
-- Name: customers customers_segmentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_segmentid_fkey FOREIGN KEY (segmentid) REFERENCES public.segments(segmentid);


--
-- Name: customers customers_stateid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_stateid_fkey FOREIGN KEY (stateid) REFERENCES public.states(stateid);


--
-- Name: orders orders_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customers(customerid);


--
-- Name: products products_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.categories(categoryid);


--
-- Name: products products_subcategoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_subcategoryid_fkey FOREIGN KEY (subcategoryid) REFERENCES public.subcategories(subcategoryid);


--
-- Name: shipments shipments_orderid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_orderid_fkey FOREIGN KEY (orderid) REFERENCES public.orders(orderid);


--
-- Name: shipments shipments_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_productid_fkey FOREIGN KEY (productid) REFERENCES public.products(productid);


--
-- Name: states states_regionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_regionid_fkey FOREIGN KEY (regionid) REFERENCES public.regions(regionid);


--
-- PostgreSQL database dump complete
--

