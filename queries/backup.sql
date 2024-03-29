PGDMP     +         
            {         	   project-1    15.2    15.2 L    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16398 	   project-1    DATABASE     �   CREATE DATABASE "project-1" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Indonesia.1252';
    DROP DATABASE "project-1";
                postgres    false                        3079    16520    postgis 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
    DROP EXTENSION postgis;
                   false            �           0    0    EXTENSION postgis    COMMENT     ^   COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';
                        false    2            �            1255    16519     haversine_distance(point, point)    FUNCTION     0  CREATE FUNCTION public.haversine_distance(point_a point, point_b point) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
	lon_a float := radians(point_a[0]);
	lat_a float := radians(point_a[1]);
	lon_b float := radians(point_b[0]);
	lat_b float := radians(point_b[1]);
	
	d_lon float := lon_b - lon_a;
	d_lat float := lat_b - lat_a;
	a float;
	c float;
	r float := 6371;
	jarak float;
BEGIN
	-- haversine formula
	a := sin(d_lat/2)^2 + cos(lat_a) * cos(lat_b) * sin(d_lon/2)^2;
	c := 2 * asin(sqrt(a));
	jarak := r * c;
	
	RETURN jarak;
END
$$;
 G   DROP FUNCTION public.haversine_distance(point_a point, point_b point);
       public          postgres    false            �            1259    18820    ads    TABLE     �  CREATE TABLE public.ads (
    ad_id integer NOT NULL,
    title character varying(255) NOT NULL,
    product_id integer NOT NULL,
    seller_id integer NOT NULL,
    availability boolean DEFAULT true NOT NULL,
    bids_allowed boolean DEFAULT true NOT NULL,
    price integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT ads_price_check CHECK ((price > 0))
);
    DROP TABLE public.ads;
       public         heap    postgres    false            �            1259    18819    ads_ad_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ads_ad_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.ads_ad_id_seq;
       public          postgres    false    233            �           0    0    ads_ad_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.ads_ad_id_seq OWNED BY public.ads.ad_id;
          public          postgres    false    232            �            1259    18840    bids    TABLE     �  CREATE TABLE public.bids (
    bid_id integer NOT NULL,
    ad_id integer NOT NULL,
    buyer_id integer NOT NULL,
    amount integer NOT NULL,
    status character varying(20),
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT bids_amount_check CHECK ((amount > 0)),
    CONSTRAINT bids_status_check CHECK (((status)::text = ANY ((ARRAY['Sent'::character varying, 'Cancelled'::character varying])::text[])))
);
    DROP TABLE public.bids;
       public         heap    postgres    false            �            1259    18839    bids_bid_id_seq    SEQUENCE     �   CREATE SEQUENCE public.bids_bid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.bids_bid_id_seq;
       public          postgres    false    235            �           0    0    bids_bid_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.bids_bid_id_seq OWNED BY public.bids.bid_id;
          public          postgres    false    234            �            1259    18768    buyer    TABLE     �   CREATE TABLE public.buyer (
    buyer_id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(50) NOT NULL,
    phone_number character varying(20) NOT NULL,
    created_at timestamp without time zone NOT NULL
);
    DROP TABLE public.buyer;
       public         heap    postgres    false            �            1259    18796    buyer_address    TABLE     �   CREATE TABLE public.buyer_address (
    buyer_address_id integer NOT NULL,
    buyer_id integer NOT NULL,
    city_id integer NOT NULL,
    address character varying(255) NOT NULL,
    zip_code integer NOT NULL
);
 !   DROP TABLE public.buyer_address;
       public         heap    postgres    false            �            1259    18795 "   buyer_address_buyer_address_id_seq    SEQUENCE     �   CREATE SEQUENCE public.buyer_address_buyer_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.buyer_address_buyer_address_id_seq;
       public          postgres    false    229            �           0    0 "   buyer_address_buyer_address_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.buyer_address_buyer_address_id_seq OWNED BY public.buyer_address.buyer_address_id;
          public          postgres    false    228            �            1259    18767    buyer_buyer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.buyer_buyer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.buyer_buyer_id_seq;
       public          postgres    false    225            �           0    0    buyer_buyer_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.buyer_buyer_id_seq OWNED BY public.buyer.buyer_id;
          public          postgres    false    224            �            1259    16422    city    TABLE     �   CREATE TABLE public.city (
    city_id integer NOT NULL,
    name character varying(255) NOT NULL,
    location point NOT NULL
);
    DROP TABLE public.city;
       public         heap    postgres    false            �            1259    16421    city_city_id_seq    SEQUENCE     �   CREATE SEQUENCE public.city_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.city_city_id_seq;
       public          postgres    false    216            �           0    0    city_city_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.city_city_id_seq OWNED BY public.city.city_id;
          public          postgres    false    215            �            1259    18813    products    TABLE       CREATE TABLE public.products (
    product_id integer NOT NULL,
    brand character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    type character varying(50) NOT NULL,
    year integer NOT NULL,
    color character varying(50),
    distance integer
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    18812    products_product_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.products_product_id_seq;
       public          postgres    false    231            �           0    0    products_product_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;
          public          postgres    false    230            �            1259    18757    seller    TABLE     �   CREATE TABLE public.seller (
    seller_id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(50) NOT NULL,
    phone_number character varying(20) NOT NULL,
    created_at timestamp without time zone NOT NULL
);
    DROP TABLE public.seller;
       public         heap    postgres    false            �            1259    18779    seller_address    TABLE     �   CREATE TABLE public.seller_address (
    seller_address_id integer NOT NULL,
    seller_id integer NOT NULL,
    city_id integer NOT NULL,
    address character varying(255) NOT NULL,
    zip_code integer NOT NULL
);
 "   DROP TABLE public.seller_address;
       public         heap    postgres    false            �            1259    18778 $   seller_address_seller_address_id_seq    SEQUENCE     �   CREATE SEQUENCE public.seller_address_seller_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.seller_address_seller_address_id_seq;
       public          postgres    false    227            �           0    0 $   seller_address_seller_address_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.seller_address_seller_address_id_seq OWNED BY public.seller_address.seller_address_id;
          public          postgres    false    226            �            1259    18756    seller_seller_id_seq    SEQUENCE     �   CREATE SEQUENCE public.seller_seller_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.seller_seller_id_seq;
       public          postgres    false    223            �           0    0    seller_seller_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.seller_seller_id_seq OWNED BY public.seller.seller_id;
          public          postgres    false    222                       2604    18823 	   ads ad_id    DEFAULT     f   ALTER TABLE ONLY public.ads ALTER COLUMN ad_id SET DEFAULT nextval('public.ads_ad_id_seq'::regclass);
 8   ALTER TABLE public.ads ALTER COLUMN ad_id DROP DEFAULT;
       public          postgres    false    232    233    233                       2604    18843    bids bid_id    DEFAULT     j   ALTER TABLE ONLY public.bids ALTER COLUMN bid_id SET DEFAULT nextval('public.bids_bid_id_seq'::regclass);
 :   ALTER TABLE public.bids ALTER COLUMN bid_id DROP DEFAULT;
       public          postgres    false    235    234    235                       2604    18771    buyer buyer_id    DEFAULT     p   ALTER TABLE ONLY public.buyer ALTER COLUMN buyer_id SET DEFAULT nextval('public.buyer_buyer_id_seq'::regclass);
 =   ALTER TABLE public.buyer ALTER COLUMN buyer_id DROP DEFAULT;
       public          postgres    false    224    225    225            	           2604    18799    buyer_address buyer_address_id    DEFAULT     �   ALTER TABLE ONLY public.buyer_address ALTER COLUMN buyer_address_id SET DEFAULT nextval('public.buyer_address_buyer_address_id_seq'::regclass);
 M   ALTER TABLE public.buyer_address ALTER COLUMN buyer_address_id DROP DEFAULT;
       public          postgres    false    228    229    229                       2604    16425    city city_id    DEFAULT     l   ALTER TABLE ONLY public.city ALTER COLUMN city_id SET DEFAULT nextval('public.city_city_id_seq'::regclass);
 ;   ALTER TABLE public.city ALTER COLUMN city_id DROP DEFAULT;
       public          postgres    false    216    215    216            
           2604    18816    products product_id    DEFAULT     z   ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
 B   ALTER TABLE public.products ALTER COLUMN product_id DROP DEFAULT;
       public          postgres    false    230    231    231                       2604    18760    seller seller_id    DEFAULT     t   ALTER TABLE ONLY public.seller ALTER COLUMN seller_id SET DEFAULT nextval('public.seller_seller_id_seq'::regclass);
 ?   ALTER TABLE public.seller ALTER COLUMN seller_id DROP DEFAULT;
       public          postgres    false    222    223    223                       2604    18782     seller_address seller_address_id    DEFAULT     �   ALTER TABLE ONLY public.seller_address ALTER COLUMN seller_address_id SET DEFAULT nextval('public.seller_address_seller_address_id_seq'::regclass);
 O   ALTER TABLE public.seller_address ALTER COLUMN seller_address_id DROP DEFAULT;
       public          postgres    false    226    227    227            �          0    18820    ads 
   TABLE DATA           q   COPY public.ads (ad_id, title, product_id, seller_id, availability, bids_allowed, price, created_at) FROM stdin;
    public          postgres    false    233   �\       �          0    18840    bids 
   TABLE DATA           S   COPY public.bids (bid_id, ad_id, buyer_id, amount, status, created_at) FROM stdin;
    public          postgres    false    235   >w       �          0    18768    buyer 
   TABLE DATA           P   COPY public.buyer (buyer_id, name, email, phone_number, created_at) FROM stdin;
    public          postgres    false    225   �x       �          0    18796    buyer_address 
   TABLE DATA           _   COPY public.buyer_address (buyer_address_id, buyer_id, city_id, address, zip_code) FROM stdin;
    public          postgres    false    229   �       �          0    16422    city 
   TABLE DATA           7   COPY public.city (city_id, name, location) FROM stdin;
    public          postgres    false    216   ��       �          0    18813    products 
   TABLE DATA           Y   COPY public.products (product_id, brand, model, type, year, color, distance) FROM stdin;
    public          postgres    false    231   4�       �          0    18757    seller 
   TABLE DATA           R   COPY public.seller (seller_id, name, email, phone_number, created_at) FROM stdin;
    public          postgres    false    223   ��       �          0    18779    seller_address 
   TABLE DATA           b   COPY public.seller_address (seller_address_id, seller_id, city_id, address, zip_code) FROM stdin;
    public          postgres    false    227   ��                 0    16833    spatial_ref_sys 
   TABLE DATA           X   COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
    public          postgres    false    218   ��       �           0    0    ads_ad_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.ads_ad_id_seq', 1, false);
          public          postgres    false    232            �           0    0    bids_bid_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.bids_bid_id_seq', 1, true);
          public          postgres    false    234            �           0    0 "   buyer_address_buyer_address_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.buyer_address_buyer_address_id_seq', 1, false);
          public          postgres    false    228            �           0    0    buyer_buyer_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.buyer_buyer_id_seq', 1, false);
          public          postgres    false    224            �           0    0    city_city_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.city_city_id_seq', 1, false);
          public          postgres    false    215            �           0    0    products_product_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);
          public          postgres    false    230            �           0    0 $   seller_address_seller_address_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.seller_address_seller_address_id_seq', 1, false);
          public          postgres    false    226            �           0    0    seller_seller_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.seller_seller_id_seq', 1, false);
          public          postgres    false    222            *           2606    18828    ads ads_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (ad_id);
 6   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_pkey;
       public            postgres    false    233            ,           2606    18847    bids bids_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_pkey PRIMARY KEY (bid_id);
 8   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_pkey;
       public            postgres    false    235            &           2606    18801     buyer_address buyer_address_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.buyer_address
    ADD CONSTRAINT buyer_address_pkey PRIMARY KEY (buyer_address_id);
 J   ALTER TABLE ONLY public.buyer_address DROP CONSTRAINT buyer_address_pkey;
       public            postgres    false    229                       2606    18775    buyer buyer_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_email_key;
       public            postgres    false    225                        2606    18777    buyer buyer_phone_number_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_phone_number_key UNIQUE (phone_number);
 F   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_phone_number_key;
       public            postgres    false    225            "           2606    18773    buyer buyer_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_pkey PRIMARY KEY (buyer_id);
 :   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_pkey;
       public            postgres    false    225                       2606    16427    city city_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);
 8   ALTER TABLE ONLY public.city DROP CONSTRAINT city_pkey;
       public            postgres    false    216            (           2606    18818    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    231            $           2606    18784 "   seller_address seller_address_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.seller_address
    ADD CONSTRAINT seller_address_pkey PRIMARY KEY (seller_address_id);
 L   ALTER TABLE ONLY public.seller_address DROP CONSTRAINT seller_address_pkey;
       public            postgres    false    227                       2606    18764    seller seller_email_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_email_key UNIQUE (email);
 A   ALTER TABLE ONLY public.seller DROP CONSTRAINT seller_email_key;
       public            postgres    false    223                       2606    18766    seller seller_phone_number_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_phone_number_key UNIQUE (phone_number);
 H   ALTER TABLE ONLY public.seller DROP CONSTRAINT seller_phone_number_key;
       public            postgres    false    223                       2606    18762    seller seller_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_pkey PRIMARY KEY (seller_id);
 <   ALTER TABLE ONLY public.seller DROP CONSTRAINT seller_pkey;
       public            postgres    false    223            1           2606    18829    ads ads_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_product_id_fkey;
       public          postgres    false    4136    233    231            2           2606    18834    ads ads_seller_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.seller(seller_id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_seller_id_fkey;
       public          postgres    false    223    233    4124            3           2606    18848    bids bids_ad_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES public.seller(seller_id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_ad_id_fkey;
       public          postgres    false    235    223    4124            4           2606    18853    bids bids_buyer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.buyer(buyer_id) ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_buyer_id_fkey;
       public          postgres    false    225    4130    235            /           2606    18802 )   buyer_address buyer_address_buyer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.buyer_address
    ADD CONSTRAINT buyer_address_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.buyer(buyer_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.buyer_address DROP CONSTRAINT buyer_address_buyer_id_fkey;
       public          postgres    false    225    4130    229            0           2606    18807 (   buyer_address buyer_address_city_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.buyer_address
    ADD CONSTRAINT buyer_address_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id) ON DELETE RESTRICT;
 R   ALTER TABLE ONLY public.buyer_address DROP CONSTRAINT buyer_address_city_id_fkey;
       public          postgres    false    229    4116    216            -           2606    18790 *   seller_address seller_address_city_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.seller_address
    ADD CONSTRAINT seller_address_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id) ON DELETE RESTRICT;
 T   ALTER TABLE ONLY public.seller_address DROP CONSTRAINT seller_address_city_id_fkey;
       public          postgres    false    4116    216    227            .           2606    18785 ,   seller_address seller_address_seller_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.seller_address
    ADD CONSTRAINT seller_address_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.seller(seller_id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.seller_address DROP CONSTRAINT seller_address_seller_id_fkey;
       public          postgres    false    227    223    4124            �      x�m\ے�F}n~`T�_��'�S�q;�_8�j$�%���_��f+��3�؍���o��r{]�t<O�t>��k�}��N�y>���e�.�0�����m��]�~:,Cz_��r����u<NK:�.�.}z����x��a��o�/���t�]w���:]S�s~����<�G�~�O��t�^G�����.���÷������Ȋ�!��*��}���*)�X�t�9�|�t�����a�>���9��}�Ӑ�GX����������6����3l��mz�]����x9���˽�NG�+<��K�����D��LO^&�,Z��s�]ȳ��l�[(���ڇ<�Me�>��2����aaCW�	.�͚�p��.���2c��N�lxf��a>_�7�����x�������2�W0����� �f��&��Y�ᶤ/��8�K�C����|��?���Q��](���-�`��6�gY�fž��y�T�)�����0_^�˴5 }z�a<��L��V�/�?����̔���_��#<g�_���2�/�`��)����^w�y��ʗPV���"ͪ=�S�I�=;o�`��^_���<�w��%��4�#y��
���^^�����t��&�.����E܅"�]Kˬ7�T�JSp�2ۗ]҄?�lt�����f|w��������2����:��4lF| �� .�~U�߆È����e|����c1և�o�w"��#��8S
�f屠$,��,��=�A�rؐsÚf1�t��<��)\��,b�� ��	��	��x���Y����ս�(c �M���k�"����>�/%�O��g@�:�%;_�n����p�u҅�n3B}ހ~x�u=��2��e�p�٪��􌏾��7� nN�"���?������d[��ӄ՗Cن����l�?�Ҽ�S�ʤ�#�r��a<�_�b��~¢��"H�����.�+�d�.H�x��&譋;�vhԬ�WE�n!g�����O��kz�&�gYE�a���?� J^�dq5
fhg����h-�;�?���� :��ac V��7����6��f_gI�����'��+%�NJP��ӌ�#~���?��iT�4{�Sl$
���B�$��mM��a�;>��W� ���A���e�e E���y��pb��,̓���GvZ!l�֬i��(7�,��cFO+�
9&5�Φ���U�Z�5R�e�e� t�� �c�G���l9��'�5��p{x������5w�0*�A�.����	8x�l���>"6��B��`����]�G٦���lNZ%��$�£�9X�U�!n��{_�x  0�jp>^�80��(�RBSz2e[�vp��O�B���ؽ	]�[�>��~E��n��ͳ=�8���{{�2�^������\Α-cƼc1f(WF4^��d*�宆2m��׭C���lh�,	�xg�#D��p����?�i���h4F�J�Nc�cMd?!��(�n�D	��ŕ��#R	�A����+	H,9��N�n�ۄ�Rcf)�}�'y�%���c�N���Da#q�'9�Y�R*��i'/���R$��ڥ��S�'`��;3���^�vA ���ԟo�~�1L�m�w�4%�3�8~N�ld�}�\̧�»t��Î�	�p�����9{��
�!V�pr���AB�5�ƚ�Hs�t�6�ȱr�8u�A�� �}�]1,i1�2���-�,{��=�)s�1���	\�#��NYY9Q:<;��B��7KW�mZ��k�Y�B�&�X�b0Ģ�bm�1GGtC�����	7�br`�����������K�&FWܕ�LXk�9�Y�a�%Q^��j_�I����Y�(���^�}:�9p������)��x�ە@�
���r��uו�Z����l�48�L�.Ʋb�2Ҫ1���07�����Q7��Uy�W�
_�A$w,	��vG�,X�4(	e0�m���<��W��	]��{�u�=:��O�,���������� e���+.�Fh@�'�R��ǀ���0��w:;�2�"�9�7g	F�g\��pb,6��`����(�AJH����*O�g® b����公&���cV,�)D��)�����1�%��e�#!�zby��)�Ɍ�"��w��A`�+��N�����W"��E��Zҡ��v�:�8���w�g*�#�/�'J��H��h2Y��Hh䒌�`L=g�r��Cѧ�����"V�c��q�	�Fvn���:�BQ�>���'B
�d��ȁ_��bz����5�T`�����,�r����4G�ڗ=]`�Ut^���ְ��M�{'&S�����f�0m���]	;�����x^�����e�(�%@Yt�b���<-�������5��%�w�����;��Hy�'�;>#�m͊b�h�_gȏ軡�B�E�	�4������Y�突n�ObDR\�ω���e������a8��r�/t�Ƥ0�0�"��$�7�Ȳ��Ү�?8V�A��� �gf��c���[:�]J�����b@�9千����v\�kp�t��&)��w�pZy*kֲ����A��N��-�ZWJ+wG��xn��X<^)�����+O39�a�v%El�т���!9��,!b���&��°������F��c����x�d#�	 �AFq�6k3�/ ��j�m���B��Q<*�������_0�Y+��U��E�$�GH#�r�ϝO�@�B,��$�[�V�b��E��d�ߊD��EƲ�w�����"S�JB{��c��-kό%*`b�r�m�jCBP�l�l���Mnp�;���G�^���H\PgؼT��d�_`�H�˟c�G�<P����M/}�DQ��1cA�`!h���K�ĎI󤱤�B`��~Ū���5d�Uhެsj�ը�T௨�OB`S�� ��d���ʵ	ƅ��z��-A}�I�y�{ y��j'�R͈��>���N��dts\"/�$�{зc�{y�CQA�B=��tMjg�A�5^�#ը;�KUH�`�n"��R��]���P��A�D	]���Ĵ��Xsi ��v�=l�N���{YR�� f��w��o�a�����]� �PuD,�Mm[��^�kp�*���ّ� ���'j�D܈�`ph�GE����'Wn��sgq��y*�oD'4����E�!�fAm�7�[�� !��˪Z5�1KR��ɫWB��!6��#i,�Nm�+�8H/�zU���KP�����,���f��q8)��M�X5�w�r:j�IM�X�X��i<�d!]�f]�k�(�S�ح� /m�[A���	S�$
�|�Ȓ"��gkَ��|�l�*d���7�B)��z�G7���:o�| �+J>B?�j�֍�I�DH7�+�j'6���}q�e�72;�r�l���Q(��a.�
����t�uE�eRa�ϳL�5��%a���N��+HD7cU�k
=�t�P��ό�@"�y8y�,D�i�U6�Biϰ��Xza�^��7�>�v���)���Y��ӯ �M�V)Re:@�#������pa7��l��2	�^�����\!F���-IH��2MQ�)E��i=�Ҡ�d,
]��,}��8M,)�>��3ˬ���h�9�Y��&?�Q2�3n�w*�5��Y��q?>X�
%[߮�~��w-�&n�x�?7�6b����xddS&����� ��I�<��ZH�9ʙ+�5����X�`E�R���yB4��Ul� �3��$�/��VP�d���]��b_��
�Ex/��d���M70���q�UE�SeC��G4�mkB�3�1�x���-<W1�y������@=�����x�%J_u���.�8+T�U� �`� WIɂ���z�d"��J6�}F���2K�B�2�5�F�
�o2Q�8:�õ-�jZ�	9��Pfl_�������&:I��Z���֩��v��Rb��z_���92 ��F�6�3Lo�4��u�4H� N
  ���p���	6�H���Q�_��v	/e�/���p��.�S�I��������h��$Z��h@�V"����g�m#�冭T"�ۚzo��I�J�Hڍ6���:������iY�wKr;���J�0����܃\�Uz�j��k(a�#t�[e���U���P!Ns%eٛ7%c(�ծ�� ���hY�����0����<�ANU,���cznR-/$Ti�С�Iu�n����տ�"�<KU}�Oq**��z�!&t9���o�8,CsE4�"��q1������ul�-��c�7�tjD��$�rFR>e-dW�Q��B?���n��aM:J�4��F�-��C��Y�ϊ��ã�[
[�G~n��H������(!�	������ѷz63q�:�β-�Hւ4�N�Q'M�Y8�i�֕�L�tL�Y�����?y�7�s�G>�b	���z2E��-q�ȍ�A�W��\��wh�Q�����^K^id<� �,�Z�1�ǘ�	T?j$�$7���8�41k��d�����4w%����d?����@l��g�X�T,�l\��*}�~��>�� �{�X]����ejP���@)��~M\��F��T�e7��+$/�.�LC�������a���-S[0�Z��1N`�8���뒑JL�t8<F���H��ZL�d�AR��&�Lf���i����M�
,��觗 ^M#Z�+`�F��蒜���2{�F4�M���O'��l�e(��↠�
J"�.��}�aUiuӅ�r�$�8]'�4�|`���:;8oH�HdU#2}�#� ��[y��#�sw3����7�ˤ�/:#�[[��Ox��NR�0�P��+��W�I^7z�#S��%��޺yN�{U!��=-J��ِQ"�!�+��|�����@!���xZ��ÙB���<1��W� хF.H��"�8��@�q�� ��>���u�Q`�ȣ%�-%��}J�$+�ś�`� 0ib'�H�"D�c5T?-�ODF��*U�1�g�h��s��Y�YE�Ϥi�1]��衐�ʝ�;!^��A?m�@B���a�0���q՛�WZ����/|+�͗��\��G��Y4,}*�E�������7OH��N�m��*��0
�5�����n=�ԩ`5L�E����ʂD8��캶	�)��X�*wDm2z�~��ח~�K��1��
�.��}��b'��ټ0gB�<�:\���bp�	$:A�Ĥ���3��xsJd�7�*iZ)�~;p̶�Lcq)�e.zd�l^��X����ގ��r� �ܰI�"�T�j'�́*>�.�A�(��Hb6�^�B#^ZM��� 4�r���Q�c�1��e��9��\��!���;���ݖ<yf��=q5���\h��/�IK��wbk����Gv_HA�D�j��ƆIj��Č�2�"K�,�'�3ϴ:��)�!�@���,�J���@�,�����I%����4��E�-�p���G�~E
;��U������k�𣟼$�~�s{?�^�><3뒮Oꐴ?q���9�9ŉ��Α���g:7�7�.�� ���hg�h�b5���5lX_ ����;n��������IW�7�x �$��~/���n�8�C�o�>e%�(�@���#�֌[(��|�h��k��o՜�����̠ڭ���~�3����:voy�t��m�V��^pqaV���n�M�BpC~hr�mQې)�	T����$ ����^���ߢƾu�Xa=&�S�J���]�%LC}cT3�O���f�L�U�';����^��@�.�s��E�wF��O5���yL֫�T�X�%X���շ��5,�s�����j�<����6 �,P����J����z�LpUQ��P6�͛�c�$�����N.��c��x[A��(k�%K��+Ծ-;\鳕���&�����#w~<�i%H�Z����V�ޒ�8<<���>�[g�'~�?��V{��!]	|�����
P�S�HWո�mo��Lg�7U��.~��G��l\&}��KmR#�o`�H�TO��k��]�Q�JO��_�=m/'�x�j���t��n�-w����4�Z���w-tHC�t�P��,��f���y��1^���0ejd&�J�1��"��n��ԲĬ�Vp�,%����S���q�l��bU����%&�G�f�'����1�����Av��wA+��}k��V_e E��A0a�m�B��#/���5yw�����̰� EДZQsԼ�ObB2�����3_��F�]�����j�]������dT~H2��u'��:�bm�7AU_��p^4OQ�f&"��c�����k!���Qm�.E�M﫦�o�f�I߆OFy�M�}s�uzC1H��Oڷ^ɠ�A�Wn��V�g�2���Qb��hԻiti���(�n��9Q����&黠��Tt�oS�p������Lk��u<���%O,��@4ZZ.�&��a+��!�x+�=�+韨H介���PDG8G��oshd`�'Y�s=��D̆:�hU�rW�i_�8���d[�nWE�B��O�e���;=��@��k�{	z#�f5x��.I����K�      �   �  x�u�=n1�k��������i���W�?<Z�����V;;�8C	eR'O�|���흔U�&YUW˽(E�9HG�YU�Y��)�b>J�q�̅�Q�b�HR?H�iV��<K'U�I�GW�ʱ�(A� J)�U�%����`U��.�������z{��͚�
_�=h����� �Y.��YI&8���Z幐��"L)$��=�\�_$��˞/i����H6�<h{Q��Ëq�b¾�s�H�`������������"�u�(�wCG�N}P p;6α31[�L�r\އE�	�ݣ!�Y$w1�7��J,��t���[�4�^޼l,��$���I4����ҕɱ|���K��dr�$_��op~���x��jY�<�R> ���      �      x�}[]��F�}�~\h��ݜ�u���q��d�,���h}��ƿ��S�/Q�"�"�6����9UE]�����|�>���)6������p����o����)�s��ҧ��>��(c��,�+U�S�N��)~9oϧ���}jNu������?^.���1ղJ��bf��R�R�;���-ޞ���c]~hv���a_l򃶳��P9��/���&�nY���:�)�pŇz���Ͷ.ߞ���ˡh�'��`�*�RE[F�c�^Z�P*wg�;m���>�ԫ���>6/���e{���}/�OKg-^)�n=lۖZ��x��"?n�M���z��h��qc�:|_o����+��w�/b�C�>�M[���~U�������x��axGem\�J-�sf��Qw>�y�H��/T�t>Տ���,V|��ɒߩ�+xN��;=���%��c�aQ��׻z_����-|�(�SgνG���v��A���{�fZhU�=l����\�~���3�_�K�=n%��Uܬ���.�.��S*��ѭim�q}%	Q��W]�D3J4�����z��?������`Myr�\�_�X�*W�{/�KK���E-�-�����|(�ׇ��{��JwgV�^1�#�Ja��|��������Y����κ�,s&Vʤፌ*���F�[h_��G�����V��l�u��T�.�*VCX�>ݝb�.t(~?�dm���ug�bL)떖��;4��ԁ��Z����aw���7���+��>��2h[�>�i>�Y^*~�[�������)��\UV��B�n���"�� ��ͧ�K��Ȩ:��h֝5���EW:�����ت�Sva<c����X��wȃ�ξ��;\a��K��Sҝ�w�,�.>����[��,���|%��i��#:��=���]h��ܞ�k��]6f>b+8It
iC�Q�S��Kث->4����w���-�h�`?ؓke� .���`M5\�U\�`��7�s�S�wH�%��m�>إs�G:�^�,�;�ŏX�}���|X5O�1۱�H�)�e�Uw�Xޤ1�U\�E ���#��~���ҍU|%ė����y�s{]��5�K�j"z+��3g^��䮀c,$b=7GI�� ��m�fom��!Z�I ȴ�\U������_v�&��澳n�Ep��y��yr�(����x�]|hN��-���fs��L9!�2V��ܠ8������2O�x�]GAu�/�y�-@�h�һ>Д�U	y+p�Ko�&��Ǻ9��� ���z�[V>�����%!� �@�-~=�f��K!-x�]�`���Ť��!2Vq�e��
B$���_�j�:4�Ahr��c�
6��0>��@r����7-��'��;�"|6l���	���A@Z-l(�~�������*Zy���E��q+9ճb��@,l�-������>f�<Fo+U?ޮ��c�]��;L��_���3A�����4�Θ�҇��>�U�6
����2i	,]��,*�\��a��=����ہ�O4���F�H����U5�:�Hk��>l���	���?\���l�JAQ�p6�;����W �?��VGq���l]������!$;z�ಧ�-sǩ)?f�����I���`8�c �2y�Ƥ�J��S��p���	n��~!c��,�o� �LC	��� ,$�pg���c���=7nŸq@g8�C�G��І�g*:�T-홪��= [v����oa*�UH�Lj��Dl�)�b�j�a۫��P����-��ģq�~<D\9��idL�$�;�þ�q���PJ�ӑ#s`��W�jb� �o�3Ͷ�n��'����c��\1��ԫ���M�-_���}�)?Xu���|S��lJ�=�)�H ���>գn���BM!uƥ�j]�fx���� op�`~�/t���哧��̐b)H���DWy�����-`��/~���Ob>gk��pZ!Ù�$+yEvE%��%�~�슚�?�Y�gl	Əj���x�����f3��n77��΁�k �5�,	��Lb��w5�����X�θ(�޺a��5-l��]�
|sj�4~4��[�G���?�^���2Y?zw�	�6-�#!g���}��,�t����g�nM����٘3�2\uO'�$����
�@��M
B�=��N����"Z&���޾�Cx��'9�3�"s㎑��"�,����˦�?��[y�2�
<��T�`�w��"��?������Ց��BPL�~�2�{9:�����$��Fju��6��p:�k �6C�Y�E-��񹜓��A��Img\/	[!��t�΋D�Ye�q�؟���0_:�\�"�˨|/��~Rr�T�!�������a����@а�6��H7�z�TOOP�m�R[hg�>��+� �4׹hG/֢�V[�kf���F�Օ�ڦ'�P˨���$��{�E�+���U�]9k�uo_����ٜ�=U����#��D��������h��9CB�� �
/i(�l\ �k�@3��LVP��}���c�@�����c��_�|���ٸ��H�h�H�"�7y��zsd�����g���)[��/x�#��P6R,���d�P�����X�:�=T��W���S�� ��,�/��l��9õЮ��ܙs߮H�d��P%	�W,� ���-nNBU[ޱs:CG���T-�H����߾��b�����y�f�κee�`�JX�-�J-bb��҇uY�D7&3�&�i�
���X1���]}���/ P)$0��$�H��Tnq��"!&����,�"��4>[��i$�$kƢuG����~���#����X�,�C�}�����[�R�0<9���cۈZ��_�Gc����iÄ�XC�w�Ul�J�����57������4;�j�{��D���"���1��"��bb����7�4F2Uz%z;����Xo�쟈�,Ɯo�V�ɬ��!܌�s#U���|��WU@߱.�i�zs^�L)8m�E��s��Ǻn{n�����?���
���(C�����D��"��o�����������-��KUٵ�,�|���.�P]
�k[E��lU�g=�O�T�D{L%��Si)�x�9?����JZ(�-���5ґ�d$W4����O"8*��<$I�ޛq䗕)�<<�����;.^`m;�Z;��cLNhE΅{�m'E�f�ޮ	�5p��F8�sd���G岈���)��.���nm�?`�ٱ����6Q�T%�-[��1�]����~xr�kPLJ0,�jX�^�C��ZpA�_��V���^fUsJ0I��'��h�Nл�HOG�`���vW�,������e�g3�B!;���=GE�T%l]�v��� �:�+"M��*��.�X?J�l��)��oq; #�a����q�,c	�"�W~(Z:a�V�Yh��	�aG�T��/b,�Z�<i�(���JcQ]|���9�>���"?�cq�b1J�Qױ� EF��)�J�jhX���\�]��yq|�I̡����g"�<"O9,h���2�q�렫�f�3�`�P��c����|�F�j�x��oGeBB��d�^ ˴Kg{�Jɭ%�<%��d6�������l*�sdA�q�?=���A2'x��_�b�G��'7s�� �c�P~�B�dV��c������x<���}�=�{��cw�E3☔��T��o��_�A9>��e�ԵuEU��G�W��WR��A��9%1i�Ӽ�里J�-S�j��
4��9�����IsUyC��*�6Z���e��BfV�B��
����󣔏�8�S��4��5����� 1rl��'����
����L�u��ټ8<��[R�<c�c�R߉t�z�����A��g�<W`M�����Uc��l��`���o���{��WahpTgf��$��JJJܹ/~X�^��ى�oT� k�ILU�\�W�d�� �u(^�U�9������;Ω2%xqbN�]X6ץ�~�%�Ry#F�|�i��(+�٢��Y���(�8�=U������U13�[8MXV~��V��� #
  $M���	��C<>"ȃ��oN�t͸Rt� ��9
����{���/wƞ:s�';��.3Py��ư�k�F�;>֛�ͩ��!�D�Л�C<D����cǕ�wȤ߶���7����I���}�Hr�X.�j�F�O���g�� ��	h0���V�PƢ&%:��#�P�!��?H����/��y���KeT�n,g��(q��e�fM�z�d�f���W�@#tlPp�0��m�3F��@�ܻ@1�O��95�e���1lؓ�2
��bOg����]!c=ֱ�¶�7ci=�s�@��c�ԽJ�R�8,�F-�U�'VfLRl���r���_�*·=��f�yQ$5��TFc'�bi���]h̛��5�o��y�n�KoS��� �7|�b|�(���00��jH���Y�"8w#��Us�����a�{s.�@�(�qЋ3�{Z����'B� �0o�Xd�2_TZ�G����Zx��.�'Sg#�ɼyY�o��!	�4a�V*g$Ȁ���zг-�[r�� =ƙ�a`�w5~_ItZ���������羛dܫ�(F���g���	�R�d���*י���i�)r�S��2�˵du�_�CR��z����낭gqʳ
<�ln�$Z �mv��@���.��<Ѻ:�� ��#csRF
�؜�::�X���g1��)Kh>@k%�L:$� ���{a�8N�nX=LS^�?�.�
�6��f=�rl8չk�[��V�l+f��y>C.!��U���p��π�o�m�N��I�A�����6q��\����>&��'��I���4���J����v�;�4A�}Ms�~p�J�Q}q���c��xB�*�x���h��̟s>�%�E�d�M����~���f�I��"E#O����	D2K[�I	Nʷ�=�^��'��v��l�쭑P�ߩ�����6[���[	�j6����ahA���5�\2D�/x��r'�d��-l{>�ʉ�d�4�f�mC���=�A��������θҚ,�D���qv���}^D`��L�w��g�;�����4Tn<;7Nj��??l�*��'��1�ٺj�s<zf�0_Q��Qh�w�pՆ���t�s���ǧ��e�A����iS��<M*b����4����n�ʈo���R?#=MBx}��x�����v���׎On`� �Ő>cYq����!>�� �G�����Oٺ�
��:"h�VdcUK%�g�����M�5�`����>P���
��� ��ҏg��
�쭺B��*����V"n��*~�ϟI@���I��҂J���)��8�a��#������-_�uC�2q�g�����d�\I3��B*fN�&ŚY�sp��BBe��	E�x7���r����{��g����1~�8��3�h{���'��}s��W���ĂpKڎ����nh���ä��a�ۭ��H�.��c�K�������',��y���fN��sll��Qa�Z2�<�f� �`]����7�e_��+IBI�[���!��_&�-�#��q�)N
=��y-y���rx<}��l�*々ι�L�L#�$���=�w�~���/��z�䔽�,���Ӻ��o��ݧ@����;�������� >�7w3��ab~���Z�>��7J��22K������C[To��u��nk��2I>�av�FW���l�)�3�a��r��.�.8P��)�h��?@vA,_s~��g1WٚI.��SnBRYΉt2�(ё����9�W2+ޕ{�'�"�-!"��&ðYz�1~/���PΑ��P͹����p釒1&6��2&��z���k��y!{v�[8���6ql�1b*�,��e"�6�D��� &R��J'5@����w�l�?� ˬ�ͦ.>��5[W���O�b�ֶ�O��\��)�c�Ҟ�uZ�Fw9\�	�1��FQeV:���T�&_i���ZWsD��ȯܪ4Iz��K��Ă�㹝�����1�?(/��Y��I��a�'�����g��0o.Y+�ao&]"������%-�����<���*?�O쁷�Ҏ��n��p�c��%/w32|q5�9Ë��]�c�k�f�%�S{���f`��[�{P���Vql[����EVH�/3O?�:�r�6_� �� m·�A�E�ᏧgVy��9�ϸ 䟲����K6x*�*�}�YɨT���f�^��/-`���q�s�����F*Al�sMȡ�|[k�sO�eq�*����^����݁�uCYy�~[�X�.��$��z�z���z��� �z�6�cC8����6��n�7�����RY93N>eM�sZ��>]j�:?��(�H���&J?�PR�|���8���5����*�WM�:]q]�O�B��TU3����P�&�\�$q(�#�3����h���P�~��I�L�p�n7�^��rj�1)o�87(#�}��v��g>�)��.�>�s��l�֬
���\��w�W���D��C�)�v�S�˥ja��Th����L�飐nmJ*L�|Ḭ����b��&}�d      �      x��Z�n�8|���`�/�N2H&NF��`���im[�u��~됒H�����Dl��u�T�ZRY^��N�͛�/��7�����\���NU��kYHme��p�yh�O|߄��vz����X�ת��([�sY�闿V]��0B~;���ꂿ87Չ�ƚRF�[Ǽ���S��7��>c��vz�O����ק���1[��x*������j_u�*�
�a]����ϭ^���qq�{�����?���a��c"����Be��x챶����|��C�M�kWuwD̬ѥ+������z�f.M��o�c�0��v�\(�/}�pi�0�s���f�:n� `io�#��6%g�X��T8��;�t��9�]����2Z	Wr^p.���~>U�qI_���S��֪�W���z�6�C�7�� ;�Ey����)��PQ@� �?�C�y�%\&��w�S{ .vm��к�0톦�N>�<n>T�k{j����;6~]b�.h��N�����X�vuG+ Tx�|�M1�C��K��.}!���0,�F��՚���6]M�r(��
gӊ��n6n6�Z۸2��8�a]Ͷ>��
e�%��,����;�rs�C1�}{�N�13֕�^��,��<��L�+JAGo��!+d��>����@�u)D�dL���s���C��� 0�m)d��6|�' �1����H�! �6Ƙ,��⠸�w]�	��*A7d���R i�8׈�!/�H��"e�0�,+#��j$���J��X�5&�w4:��]i��7aa�z�Y,���	�|�~6?��q� �`@bĳ��$X��u�|���w��a�Bt�K[8/$x��F0_S����X)y!m��/3�Q��COM����19,	�W��a�%�����t%��%����^6���:W)���~�p����ΝŵQ����?`�3��0�x)u̕����@^~�.�+c =�',��I*O��,��w7Hү�s����ks��s�pzh�/�ч��F���Pw]�s��W�!��e�d��y#f�Y��\w�z�:FU�:R��V�qƩR���D�����.����Rq�=U����R#3��yHA�����q-J%������!�(2�)|/�b"�ωF��������t��
����RI i��/cI��zW@Q�4�.���1q��y5̀�U �4�������*�P#m��'�8�Ö
�@%�����]3�	�a�P�r���8}��c�(lۜ�����0\-8�ǮD~��n�|E�w����8m�/5�m9�y?"�)���u��J�u�k�
/��s��wW�ǚ��Rr����.?��%&����`��H+����wd�i*m�fzQH�l)|�J�1P P��dٿ"�8��]�҂n$����p�|Td~`_1����g���K[-D�Q6p�S�әU�}�N�k����95g,��L�5l��\��M�R��>�ɯ�T�fY���4�fVᒾ�xO���8+�z�˳z=���؇��?����^`���@�AK/���j���F)W�Hf��k�_���S��������3]ٓ<�P�'C�q��G&+M�Y�[H�@"=��C����(K�D�n��@��@d����{�4��)�/-�ڟUwn.���^�{'��,�<B�x�5/���g��� ����%�o2���Z�%hL^�U�I3���P�b�˰$��%j���ؐ>���$�P�;�/{Sb~b��K�X؂�
���o��qI�����;�J]�Y���%��g<���n�o�\��r�B���c`u(���0G��)��N�!+�0I<��R���z� ��фd��9���
g!<9ىC�S����I�G����M�<�٥k,�c��؂P��&3��}�Q�9��	$,���dlWwt���В9Q:�{�٢k�����a�Ц��z���c�D�8�#��!:
����3�e�*66��GP^��g8�� ��A���ˍ�6���#H�>�v<� ثbBH�%*	��*�[(p�ո4*A���L����΍繦��K��*T:$���:pF}�	��Q�(v>�n�ykDQ:�?�҂�<� ��j��!��O�͹�	�r�]��jQ5�U��6,�w�����v�)'��3�@�|�K!#1qb"$�/�<Ѽ%Q���3r�
�J��2�G���}�����z>�Suc��&�&C�j"�y�Idz�F�����ծ���N;Vz����*XV�GU���p6d��̭����J�n� i/Լ����0;��\�8:���°��ߪ�~�٨h54�+1J�Tf��_�{2)�8�za�S4�̀Sm��bI�����T�)!Q,��b&�t��֚���L�u@Y}�N�`@�X���.C���L:6E�O��3aiQ6��F�}n�EznFEI�xh[hx!���w��u8d�u�$�����Q�`C�*��,9u�Oe|���~'NB	�b�:��o�e�֚n���kC�pZ5�Y�	�ms7���nԷ�L�B���국�c-�ZQO�:�"�������5��`Aa4 ̓tH�!jNP%�P2���\�ͱu�a���mr�jˌ�Rn'�PfEL�<c��(:��F��D.脀Gy�}�*�W�w,o�ha�)�I����Ӷ? ��y0;b<��h�xh�&`�}u-Sqr��n@�C��JDc/c��ҙz5N3#C����+�d�@�P�LT�{Z�*��Թ�ԄLI�X?՗����j�t�� M�j+)lt*���퐙��Y,y ���y�֡��Z� 0��F��
���������#����l�u�g�P�%Ng��#�����@���9ւkv���%�B]LN��s=xn@C����:P�=!���Q=�b�T�Q��PTWj8kM����˨�-�$��w�:��aYWb��Y��� ���Z-�]|P�x�#!�h_�NgE���	F�~ͤBH:%H	��{Q�tַC�8���/&���&G�ؾ⅗���Y2x�v�o4�L�G�SzO1��iyc�EX�*��+�u���`ڹR�#6��경b��`|���PZ������^C�jMuB���W�ܚ����Nե��7�BThR����c�J�B���p�M���w5�/2{�R�.�/a�ʛ���!1%D�l��.�;q^0J.��ؑ�%���/���k�dr�iE����p"�-J�3Ӭ=c�(���59O�k���&ctPR�Y��(fͩY�[�_z�qj0 �"c��ݒZ�yHI��m1��B ��"���P�@�M֮_�b��+l/��4'O�F��6��aet�
�������|zn��?V?k��
w���Ԛf>�8
Q�i@�e�Gd<���S�M�(,�H��������[o�05{��	��n�1!B�A�%��:��[5S��P���iI��7�� )!J	y���͕�M��߃Dv�V3����E�"��1��hO�����.�8j5q�
5���_W�i�NI��hu�U��)�8���^����*ng�`�󈫕!T1	�����ڏ���Jj-�*���T�ͼ�E��w���^��Μ���'�����0�U
#��,�bC�NWy�3'��P�A�[Au���f���.�IŝL��x'uXӅ��{�5��F�VD��9�ZI=e��ó�Y#GLg��/El�%�j]�s
��Ҋ����26�m�+|%,j/��u0�k�$�H���R��05���A�&�b\p|��0���V%�S�Q�Ȱk�df�띠 � �ӕ� ����S����˝���z�jL:l�8�ZN���7�ScF�3.�6�]�u���l���!6	�-�ɋp�:α�����2�.u�e12�/�Н{vda��z����!˧8�����kdg�I#�n�t9[u�X)\���8>�Ao���Q��]��"{6��P/����Yq�V��Ih�G��&�Ŗ�6��N{<��$q���ct�k�F�sr/.kb\���MT��'0��@ji��h� �  �m.�X�Ɗ ���H~+$��KL*���K�Ɏ]�슃���K�nh&�V�͇*�$d7�@�M���g�"�bsC�WX�g�BSҠX���G�r�Z��2'AΏ�	h�Å�ָ�ݺ�k*
��Nh���P��)AiS
zfSN,̋��_x�:��1���4{�sU��vc�N�X+�?��P���b�"~D��i��Φ�o�f�h�U�yJjy�����^#Xkm���U�U�2�
>��ܟ�F]�q9��Q��ĳ���zx4�`P8>w��8f<?�ۺ#|�����>Z�K�}��0!�m �,�ea��j���4C��2�,�Ao��wN-bA�H�Ӵk�x7e�F�iv*�t���,b�`|���^Dr��^�4�gO� i��/䒩X:X������巛�,�ج��      �   i  x�U�Mk�@�s�+z������~\��A�=z����F�����M"�%��y�n�|^zy���t��7�_��z��˕7��~Q|�߽t2��+�N�|�z�Dv�N��g�;���v��3'k��r��|5硛x��)s��q�<���I�Z�����rL��+.�n7t�'we G)f�1��m����K}3dk�R�V�y*�����㭮��B�S
4���~ju$�e�˕5��^~=��oںn&�s��e>���D]˩9^�Zz-
C���6�Kb*z�杜�k�}y�`@��wf[�H�*<�n���Mr����%���ߢ����~h�2Y6�h��U4�=��_SU�?��~      �   m  x��Vێ�0}�"?�Ub;q�H�JhWT�쥭�2\�@"��|}]��$����E:�>s�̄^�CY��~`��0�z���b,���*,�"߬*HC�0?/�ɪ�u������q?M�sY�b{��X��b���*JZ�a~�&<k�/,Mzi^���mU�^x�ܚ�AQ홏�L0_�XFz�0*7[���(j1F�5�w�˂��Y�����_�w���Z���KkPPkI�v�[����	������e~~A��z��_��a{��RR��.V?Qպp�a�+�r��^�s�=LI��D7�����k�Qu_V�*�0{}���V�M�<4�xօ*r���ދ�u!&�$y�"�4����U��
��U�&S'�2��h��h\�4:@������/i��@4X���w堁O�QWx�0����	�����Z�!���<pj�Y��n��tLh
.�=hN���
<i�G�ޚQ I8y'����pav��yv���t��a�B��i�D�g#�[-ڶ�G(��:���y���ʂ�P���4g0��<�S	��Qo���Z���.�N����g_ڋ==6�wY/��zH2��d߯O����M��      �      x�}[�r#Ǒ}n|E?Z�G�/|�XY#iF
�d���p�&���0���s��4g�cogE��.Y'O�L����c[�l�]��`���?��Ӷi��i���'��oָo�l���*��]*�4���F�[����n�]��K��u�*����xi���dF��������sF�Ty�b�ݍ必���lo�CS��ܴ��Xg�e���
˜�)�i�0�F��t���Uo��c��?����9�U#�޾^�J����L>�n��x�u䮽_��f�3�=4'�V�|*��*1[����.����U�q�F�E��ۯ���f}�[�jk����R)��}v�[TXj\������E�U��"��î��v��l���������ۭJ�.�*�ot\��^��pjk|�xr�~d]�����n�K��N�j�����E���lNm�j���9��nd�L�]����q�>�ۏ�8A}��B���fw��絼���x*��j1�^��.�����ug`�Bk�����th�7�C��p��m��k?
9~S��N��$�R����;�7���ssXտ��O�$�d੷�n�X�l�y8����o�]h[���L��k��
�Yg��D��K�7��B����lo����ޟe`�!�� �t&t��Z�n&��Op����n�����Z��iipj��q�x�X��|�:��x�?���7��x�3o2���!j�-P-����'�c�����#��b���T��=w',&q���m n�۶i�S��}l��wpͶ��{+��7���F����qy����Qn�s���o�O����~W�a�s�8<8�£��ǜ�x#��5wP�FP���!3�����.[=8#17l�������4�p��/1��5w���7u��
�.���������+[�ִŸ��`�3y��_.C�p�c���m�Ssܷ'��v�}Ov���e��7��@�����\��yho���\WM���Y���#�������7����7mY�w��}Ո�ԙ��ې|]���aYS��O�7��O�/L>'�7�pl�P��C����x
iab�������y��f�}_A�M�X�?''c��}\�T��2	��1\�_�i^: K.OH.��7����\@�G�T{��͎\��<�^a������ذ����9>����fsܶ�N2�8\�Q-s�3�)�kG5���'�n}�v�7�вjim�1#YbtK;R�rx��]��5ջ(�y��Z|o���*-^d�qU�_�#�!<hc��Z�t�nmN�'1��=9��� l� �Z5>K�7��\%�~w|n�/��J�UۛW(XnqS���s�t����0@Lv:?�����Y��&Ń77:��l��n�c�gs� �;�����X�^�O"H�(�%61ܵ��n/��3.����u��:+��߸���z�k��w3{�����>f����Ӻ�_ ��C箄�=c{
�����cR�t������"NgG�^m��f�>z����`�SD�Xܡ�՟g����;�2��c1.����|��-������T߶����c�Ө>�X��w�l�f�M�r�p~� c~��* �}w����Q5�ж��e�|R��lڒ��D~Ȑ`��a�u�r�V�>��%m7���H�<���b�dB�v[~h�=Z���J�v�����Ȭp��hp����K#�}vu��k��pv��7�t(i;F��. �����iݽ�����4��I��sɳP���g�R�{������v]�h��ʎ�-���|�>��9�>�݌ ������#þ��92�r��/�^�N���+dS;ځ�o�-�����W �m�s��lL�]G��^<s�{���� �;�G�:�ҡ1U@,�O�x��8������p��k�vWF����% ^�C�	x�,�dZx[���|w����[��=�$׸��?L�c��D������s���y�z�hPy\�(���������iN���^�����$a�H�� 	�/	�h���N&,/��Xa2fS>�1E5���i�����6�gе��Ř/.���:!+C���%��M���w\���J��h^`B9�ptCN��	A��3��(�,f{�"���>��ņy��<�
�ޣ��@ؠz��|د����5=���H�1Ԉ����A3���.m���K���V&�14���ɀ~�0VA�]IJ�-#���Ŗ3֗�G���	"�h��o)p�zw@RIN����u��0�
Ϋ1\6���������?L``�q��dJz|��i��"A��!�lq@�Ώ����2���3�\_^C��S���@�]�PQ9iO�j���nF`�d�N�qߑ���AC�!��D�mEF�ȱ��4@/�}���d�K�Qj�'����b�"Qy\����,��z�i��g.���3����K�\���OŜ˼^/S���hqj0���p�����܎�ܣ�C"wu���o��h;q/�#���{���9N03}l���׹�.��Frm�� �V-R%x�	��s'�59�Hu�h�9���]bG�շp�=�� �T�h=������c��؂L�7,"bǑP�\��X�H(L�RIP��0�"�u��&�����aJ3�q��J�[�D��fqpH
�ٜ�/-C���7_񒰴d�Ǝ�r�EZ���<�7�D�	Ʊ|_p��"AJa&oF�S��O��p%+��d��a#�U�5r�0D"��HqĹ���8���0����f1�D&���Й��#Gz�	����f� ĸ^��x�-r+���)o*i�.�����£;�k��X�gaW3�69-�U��Vi�Z�#y�ԹW�t�{]��UJu!�-i@˳��HJ$	i�so]�2D�u���a��I�����FeC�+
��AK�!@�6p;f�q�|�X�Y }W4��g�!>�:0/�����R�~lY����Dnn���Μ]J����-�Q2�TH�2�p������`���+��#]K˘l�N[�2�*1#gZG�:�CJ$�W��8�1~����Li��2W$灲 ��=_�-x%���$}�w��@Z�t�����5���l��OQD�q88c�@�p���/��^qρI!`U�
�c��(�DY�cCB����G�&(2�,��5UO�Z���l�$r xQ����t��c&܈�����,,�Q�!�܉���	ɞ�4�yL�U�X�7ڏ ��X p����p��m+Tm�ޖ�/G�V!�xǦOc��P���X5�(���J(W3F�Kv�8P0�F�S��O��M�����Oi��u>4٤�D.�����v6��w��wia������d!�OM�������e���F�eUF�"���Z:\��.�w+/זJ��'$EhCk�	s�����883e�I�F@�ߚB��2�0�׮��%��5Si��J(��Lo�n%K-������F§���0Q{`���ެ�:��Y�����o���jBuJQZ�j�_�@����=��b\o�Hrʠ�&�Hn�ˢ��$ܳ�$�S�K$a�^�!�ʛ"��Dd�H5�}���#4����b��Zd><�55b�8��5,�����X�?O��M��ؖ���SU����T��&IT��?�>�����z����k�ʬ~+��.X7A .Rr�l����O��".���,]/�:�>�צ�y+с��L�=��N}�;���|ź4�T�	3_�����cëtóد�y����b_�):!Y2?�M��f'���Ť_h�1#.f^��y f|A4fx��Տͽ�����������{e �~ *8�@��D�]#�޵́�<�f6�2QEM������"#���Jۈ���̛]N,z���u3�pg<�4v����mgw~3ۻOL�p��o�d�
w"O4���=���x�q ��1�rW�"\G8�K"U��w,�!sW���#�Ut��扊-��f�))�>< �	  �ֻ�R��Co^�%a�.��OܲƌFu3Nj�2�h>�(-'���7])�J�7bJ]:wzxe�N��׏��R���T:����h�V��;�Y�s�kJ	�p�>������<;c-�j��6bΫF@@�JSaN�+] |�\Yѭ@�YY�^��+~�9���k&����������/�s�����N��Μe\�i���/.͎^�]���e'G��	�%cl��%���J���]��i��_���!c�YA�v�*%Cdk0/����(���#/4םu�RͰ�eNa"&x��2����(&k���+��R�g�Cv}!�y����Z���D�kV��B<0 �C}�/���,���C{����c����;�C�De�bB��ة]�0����� '�˟h<����.�)Z��Nf�Ҥf8���>2�8�~�c��'E��4 ��G�F�řK�����K;� ;X�
r��&"�G�q�$@�7v_Ƒ�~ۜ�%a�߈X����0�tC�+T�0�K�F.�dA(�xG����\k��J$����!�s�umc�P	I� !Uӛ3�g�$��4"��E���^�(:�')߃|%��%`�ҩ����ϲ_�Pns��ݧ�����W2�Y:���PG,��:�.ک����v�[)��ԛ3�D�G�����J$e��p�N#]{��4�	��3���=�޵W�!?�#���LŔjW�>���O��#��Ul��U�?�aBV۟��HwIՈyl�{MdÚ�x_g��Vj}T�$t;6����^�'��tk�	֠���`,�4��=�$"b_�~�ѕ��B�F�����k�$���^���~aum[Ş汳f=���2*;)�Iu��ǻ@��q�&��V�D1��Q�ʦ��� X�(֜����$�wn��Q�c�mg���HFsıY��BR�)kj�������L��w�3?f�g)ن	���dTlO�>=�`>�)���|_x�]�Ym�P�(�S	��~ߟ·�r������M�,��	]���8Jg�F�m�2�^������j�L`5������f,�l`�k#2	"�et�l��W>S����M��jy�U1�PF���ȳ��W�+"�ФIG�[4g�7�[$OH�(���!�(f}�g�K����OY�Մ��}t�b�whK�x�Y�N�mo��h���&�� ҄����S�����p���pg�*�c� J�@'������{&($�����b�b�[f�'�oe�J�+2�ؽё+��5��ޜ��Y��L�r�3b��T����%��������=���[<Ѥ&��'ɛ�hz�@��*�n��V.�^-ކ3��w]s5%�����|���}����%9����M��G�c����I�Ʊ�4&b��H� #۠�cK���JZ���:���a(���Z�5��'��Q'�(��;1��:�["i�:�*�q������{/$`*���Csx*�ƀ�+ƬC�6�eqlVҨ�F@<��|�]s�+}M�~��̤ݬtG��'cU�A��E�lݏN�h�s�N��xnFZ�
慎L9֫���bt��p��`_K >2��K�Ҹi�'�R�`�Tׯ�*fװs9��vA̾��M�k�gє@֫�d�z�يv��:�Qf��i�w)��7�^��D�uA����� �4�[9���&�]b�(�\�y땔@�T��e���)���K�d>dX���2� ��(�������2(U�	Y���������0u9
B�8I�~y$�̪N%B42��1�R7姐øD�D���h�>u�5 �͗Κ9
y���ڌ��������ԫ;�c����2]��}uH�%X�X�T��2j����ڥ�W���C(�4;i�I��A6XW9���5�)v�8}��E�d�ݺC/����z��d���G�Dj;����va*П	(?�r,��d5���f͉o@�X'��˔4��$֏]�Z��e���3Y%�ϫz WH!�kv�R��~o��}�ڴ��<Iݦ|κj�<{Z���[�(�ZĜ䗕�1՞���Q~Y�~�b�%7v>�d�{@������g�������D�X����y�A���N������,0Ⱥ���?�>Ԉ9�/B�.?U���c�5��X�r����X~C1gMISS;=]e_��������4���\�Xb3��AJK7$�,�ywt�r��ҿ}��o�H�Y�q�)%�!���gS~$�w)P���.~�z��}'e��M��ƚ�ؓ����2�˃���3H���Hv՛�v3������ ���N�����п�w ��Q�d��z�>�~>"��KuP~�f��s`߅+�o��A�����[DY���3j'rH72"�\�-]dv@k#��EK乥귻��?���C��r�5Z��Q$Z����#=#��\z����k{����t���Ɍ3��y�z=�S�/Ç����IҰ�WD�tP-]�c�T�/%?A�߿/��K      �      x��Z�n�H}&�B?�F�/�N2�';���� y�#�LK"J����Sݼ4):3@� 1��]u�ԩ*�L�Lr��χ�����W��;m�cU7�f���jc��^��E�˴gF�"��M���bם6�NǢ:�5B������g�Y�s�y�inyXqW<�šڼ+��Vxɾ��sG�0<���k�qIk�CQo>��{.�UX�ǿ��cs��ݮɔ�^�:3�6,�P���nߵ�*WyW�[�E�Xn2!3���W|m~<�J�SVh+��h#�mƙɤ��_v��o_��T�fc�MRJ��e��N���5U}���B�{����S��Μ��h:�>���o�9J1N���C������\t"~_��sXܡh��d�19癲��a����v�x���mr�����t.�p���$��_y.�a��X�U�-2�cc�̸g����Z�����^H�s8�׸��E470g�kZX���uPwW��ϰ����H���-��_v��yʴ�����6�*lq_l�_t�]�	]�9 ���9���G��n�W7W�?��j��)N?�c�����<5�S���23³�;��迯���:�F�qb�cw��S�p2��� S#\fU
��شM}.Mf��S��Ŋw���o��z���M�j��k�ߺSq�)�f����^$Ñ������}�!(��^��9��I�C x<@�Lt�����]u�|�9z[u5�`��)�"��YWH�Q�~`�%���u���ù}��y�".�Z�)�"�v�܃�����3��	�4���gb���^�d(MF+��㹌wI����� PnT�/�� t�Nt(w8��/`�H��_�	� 짦�O"��?�ɼt��`�}����~�|%_'��wm� n"h����ۺ���*�+ �A��`ֆ��p<��-��L���-<�)�咨c
��nO�S�W>`����)gT�T�u���`�������)!xA$%C҈y�}w{��u�x����B<�7,��Ub��/���8�
F��v��[|.�-B^,����]'��k�xZɷ��_�;<n���$t��8�	��O�����=; ��0�,bdB���
	���/��]q�$s^����v�ez��T�X�Ę���.�a�-µCƅ5O�g8��zb�M�
`А�Q��@�}�������cf��>W �գ�q��]ϝxyL�*�9��u�D�S?mG��2G�ն7���u��)���z䤹�<�+G�	b��Bw|�eWE�R" Hό�B���ܙ������=�>tf"c�������������
!w
(.����������1ӳ26*��;t��"�&���r�'����^U���1���T�$�N����4����� ����5���Tݭ1��>agg%B<bM���:��y�	�T�a0=ل�!�A��5i�f���	��r~&��+	�)�i�	&�D���ef	�м4���}$��W���cWÜ�����|n�_/{<�ǿ���]xf�,�b�p״�<W`��S�6,�Ũ��ʍ�D_#D��^m>��3Nv۽��9�rC����i�]5xG�b��
&���n�H�:<��S�P���܀���E�������L�&RB���8g�V�jv?�d+9��#��������e��4-�ܐ�"9�R�m�bX0H�?��ʶ�R"�cCy���]:�ɢ��.6uS��4	�WT
]}��B�s���>í{��j�[Yw$sQ#�j�4�\:���1�?9����7\�!vN�p�Q9��%k\�ɧ`�*�������ꑛ�5f?u�1���N��Q�q)�kI'�w�@�*� 3� � �88s���UCi$�A°�I_��(����G1h tK(a=�Sy�"%�*5#���M)�s.{uL )Q	����CL��cI�F�ʌA�g֡*v��
�A�M�e���ށ-����c	}�X��U;�3U��q��F�(��n����;��r|�����=�He t�<�Tl.�\���im��@�]ړx�(��1�f�t�z��*\	C�6=ui�4&,�>G���z���:��6�P0��<�R��M�T"m2�/��5�d-pt5��BR�H\=�"aS���T`F�˻�@�P���C�ܖ�KbD���*�4��������e�i{R���@�!<*��i����F��
�2�/IsپЃ�sF���rV��������{H��K^��*>P8!�!DO��h�~Dװ�1Ts���޾-^�eM���!-�2�!�6�MȈ��P)_��3@:]ɹ!�m�[���F&��Y�|9�9�Z���ʤZ��3��`�I�S�\lG��P��\�Q�<�DM��E�hA��t0C}��`9�MV(AŜ�1IJC����i��}�gxk�Sy�n&Ǯ���1 I=4i˧6�=��OU[��]Q�*
�N�k5>6�ל����SUhv�8��*iÍ8� ��\��w�q;���uȢ/`�n�hRK�>����n�4�׊����sư�ys}���X�.r	�L�Z���ރ�������	�Z�*�Ӵt���������sn�ϒ�)� �R�p��R�g$�G��Z�q}4Ҕ��3����@*8w�Ͽ��< ��U�k,,�:��#��` ��!��2v��㄃�cs2�DpB'�(����#�����lN�͓�Ke�L��NJF�R��O,������mӖ��/ݡ�h�N�D(dG1� ��%�i��t7���
�y�^�v�T����uI�L���=�;-�%P8��П�fnB�	���p��H�S�kM�"Tg73La3I�-�s����d��K�)3��.S-�Sɏ,.�&f����K��7���l�F����ͨ�he�*\4���by���I�;J(���F����X�ξ�(榖��6;I/��t:gxEC���8d�i�J%ޤ]�k�����ڏ��E��&q�+#����
���-'�,7��#p؀�P$WUz��෋j�U3�P1�^�$|R!^8��D(ֆ���h7C8�i��$�AIr5�L��,�y
���=��e�trL��(�c�GV�O"g*�L& ��dԻ���84�=�V�2�����n$zԓ���r�HXf&��ccA���P���N�
���Z#M�����<�(-څg4g�ΨK`:\_�)��cH��YS`��tHYs=��I�h2t�E6ԅ�uԊ�iE;�&m�431�=~{�vT�JKu�	M��$D)�l�0��0���x�>�b4����a\�"Ff};���%��:I�"tAm�������@�"z���$�F���(�m�0l8��g3�Pq@GӶO��Aj{>9�s�y�O�A�m{',��*�Ә����A�̅�s΂��F�u灠����i���<�Y�MC)%�k�
֙	��ei��H&�f�����]�ٴ4��eCkg$�5&�f����A��8<5F�H�:�x�Rb�ӄ+䅅[�oI"�[F�y(h����O<�J�����}�/��u�~����1jAS�Y=����8�wR�QS��	��s�s�`� l�E����:f��0�`�|C}O�M��[��F܆C[���pe}B��<�4��f:w:�C�&(
��	��e��Hy5�>���F��[]�Da���a^R�JmQ�|��~5���u��۸��!���\˸�QM]lb~A�ȡ'��>a��V$�i�����M%��ʤh1��a0��jy*��/%}1�6|{��捹��Y��ZSM��ơ�;�\�+�`� �]?PFk��q��!�p~��r1|8p��/�v�b�(~��Ls5#�9T�a�T!i$�z__�}�m Y���B]O��xX�*q�Ja9~����)����AL�0[����)�[� �
S{�H���.,�s�.u�� tZ!NDh8U��s�/[D	ǁ?Į��7�Y���-Q����t|��� �;���6X܇��.{)ΤC|>�b!,Ơ]    ��%���]`d
��U���o���            x������ � �     