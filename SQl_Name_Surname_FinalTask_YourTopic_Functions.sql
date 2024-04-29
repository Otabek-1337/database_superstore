
CREATE OR REPLACE FUNCTION update_country(
    country_id INT,
    new_country_name VARCHAR(255)
)
    RETURNS VOID AS
$$
BEGIN
    UPDATE countries
    SET countryname = new_country_name
    WHERE countryid = country_id;
END;
$$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_state(
    state_id INT,
    new_state_name VARCHAR(255),
    new_region_id INT
)
    RETURNS VOID AS
$$
BEGIN
    UPDATE states
    SET statename = new_state_name,
        regionid = new_region_id
    WHERE stateid = state_id;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_city(
    city_id INT,
    new_city_name VARCHAR(255),
    new_state_id INT
)
    RETURNS VOID AS
$$
BEGIN
    UPDATE cities
    SET cityname = new_city_name,
        stateid = new_state_id
    WHERE cityid = city_id;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_segment(
    segment_id INT,
    new_segment_name VARCHAR(255)
)
    RETURNS VOID AS
$$
BEGIN
    UPDATE segments
    SET segmentname = new_segment_name
    WHERE segmentid = segment_id;
END;
$$

    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_category(
    category_id INT,
    new_category_name VARCHAR(255)
)
    RETURNS VOID AS
$$
BEGIN
    UPDATE categories
    SET categoryname = new_category_name
    WHERE categoryid = category_id;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_subcategory(
    subcategory_id INT,
    new_subcategory_name VARCHAR(255)
)
    RETURNS VOID AS
$$
BEGIN
    UPDATE subcategories
    SET subcategoryname = new_subcategory_name
    WHERE subcategoryid = subcategory_id;
END;
$$
    LANGUAGE plpgsql;


create function increase_order_quantity() returns void
    language plpgsql
as
$$
BEGIN
    UPDATE Orders
    SET Quantity = Quantity + 1;
END;
$$;

alter function increase_order_quantity() owner to postgres;
