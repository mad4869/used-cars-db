PGDMP     &        	            {         	   project-1    15.2    15.2 L    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false            �            1259    16470    ads    TABLE     �  CREATE TABLE public.ads (
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
       public         heap    postgres    false            �            1259    16469    ads_ad_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ads_ad_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.ads_ad_id_seq;
       public          postgres    false    228            �           0    0    ads_ad_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.ads_ad_id_seq OWNED BY public.ads.ad_id;
          public          postgres    false    227            �            1259    16490    bids    TABLE     �  CREATE TABLE public.bids (
    bid_id integer NOT NULL,
    ad_id integer NOT NULL,
    buyer_id integer NOT NULL,
    amount integer NOT NULL,
    status character varying(20),
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT bids_amount_check CHECK ((amount > 0)),
    CONSTRAINT bids_status_check CHECK (((status)::text = ANY ((ARRAY['Sent'::character varying, 'Not Sent'::character varying])::text[])))
);
    DROP TABLE public.bids;
       public         heap    postgres    false            �            1259    16489    bids_bid_id_seq    SEQUENCE     �   CREATE SEQUENCE public.bids_bid_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.bids_bid_id_seq;
       public          postgres    false    230            �           0    0    bids_bid_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.bids_bid_id_seq OWNED BY public.bids.bid_id;
          public          postgres    false    229            �            1259    16411    buyer    TABLE     �   CREATE TABLE public.buyer (
    buyer_id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(50) NOT NULL,
    phone_number character varying(20) NOT NULL,
    created_at timestamp without time zone NOT NULL
);
    DROP TABLE public.buyer;
       public         heap    postgres    false            �            1259    16446    buyer_address    TABLE     �   CREATE TABLE public.buyer_address (
    buyer_address_id integer NOT NULL,
    buyer_id integer NOT NULL,
    city_id integer NOT NULL,
    address character varying(255) NOT NULL,
    zip_code integer NOT NULL
);
 !   DROP TABLE public.buyer_address;
       public         heap    postgres    false            �            1259    16445 "   buyer_address_buyer_address_id_seq    SEQUENCE     �   CREATE SEQUENCE public.buyer_address_buyer_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.buyer_address_buyer_address_id_seq;
       public          postgres    false    224            �           0    0 "   buyer_address_buyer_address_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.buyer_address_buyer_address_id_seq OWNED BY public.buyer_address.buyer_address_id;
          public          postgres    false    223            �            1259    16410    buyer_buyer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.buyer_buyer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.buyer_buyer_id_seq;
       public          postgres    false    218            �           0    0    buyer_buyer_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.buyer_buyer_id_seq OWNED BY public.buyer.buyer_id;
          public          postgres    false    217            �            1259    16422    city    TABLE     �   CREATE TABLE public.city (
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
       public          postgres    false    220            �           0    0    city_city_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.city_city_id_seq OWNED BY public.city.city_id;
          public          postgres    false    219            �            1259    16463    products    TABLE       CREATE TABLE public.products (
    product_id integer NOT NULL,
    brand character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    type character varying(50) NOT NULL,
    year integer NOT NULL,
    color character varying(50),
    distance integer
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    16462    products_product_id_seq    SEQUENCE     �   CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.products_product_id_seq;
       public          postgres    false    226            �           0    0    products_product_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;
          public          postgres    false    225            �            1259    16400    seller    TABLE     �   CREATE TABLE public.seller (
    seller_id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(50) NOT NULL,
    phone_number character varying(20) NOT NULL,
    created_at timestamp without time zone NOT NULL
);
    DROP TABLE public.seller;
       public         heap    postgres    false            �            1259    16429    seller_address    TABLE     �   CREATE TABLE public.seller_address (
    seller_address_id integer NOT NULL,
    seller_id integer NOT NULL,
    city_id integer NOT NULL,
    address character varying(255) NOT NULL,
    zip_code integer NOT NULL
);
 "   DROP TABLE public.seller_address;
       public         heap    postgres    false            �            1259    16428 $   seller_address_seller_address_id_seq    SEQUENCE     �   CREATE SEQUENCE public.seller_address_seller_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.seller_address_seller_address_id_seq;
       public          postgres    false    222            �           0    0 $   seller_address_seller_address_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.seller_address_seller_address_id_seq OWNED BY public.seller_address.seller_address_id;
          public          postgres    false    221            �            1259    16399    seller_seller_id_seq    SEQUENCE     �   CREATE SEQUENCE public.seller_seller_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.seller_seller_id_seq;
       public          postgres    false    216            �           0    0    seller_seller_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.seller_seller_id_seq OWNED BY public.seller.seller_id;
          public          postgres    false    215                       2604    16473 	   ads ad_id    DEFAULT     f   ALTER TABLE ONLY public.ads ALTER COLUMN ad_id SET DEFAULT nextval('public.ads_ad_id_seq'::regclass);
 8   ALTER TABLE public.ads ALTER COLUMN ad_id DROP DEFAULT;
       public          postgres    false    227    228    228                       2604    16493    bids bid_id    DEFAULT     j   ALTER TABLE ONLY public.bids ALTER COLUMN bid_id SET DEFAULT nextval('public.bids_bid_id_seq'::regclass);
 :   ALTER TABLE public.bids ALTER COLUMN bid_id DROP DEFAULT;
       public          postgres    false    230    229    230                       2604    16414    buyer buyer_id    DEFAULT     p   ALTER TABLE ONLY public.buyer ALTER COLUMN buyer_id SET DEFAULT nextval('public.buyer_buyer_id_seq'::regclass);
 =   ALTER TABLE public.buyer ALTER COLUMN buyer_id DROP DEFAULT;
       public          postgres    false    217    218    218            	           2604    16449    buyer_address buyer_address_id    DEFAULT     �   ALTER TABLE ONLY public.buyer_address ALTER COLUMN buyer_address_id SET DEFAULT nextval('public.buyer_address_buyer_address_id_seq'::regclass);
 M   ALTER TABLE public.buyer_address ALTER COLUMN buyer_address_id DROP DEFAULT;
       public          postgres    false    223    224    224                       2604    16425    city city_id    DEFAULT     l   ALTER TABLE ONLY public.city ALTER COLUMN city_id SET DEFAULT nextval('public.city_city_id_seq'::regclass);
 ;   ALTER TABLE public.city ALTER COLUMN city_id DROP DEFAULT;
       public          postgres    false    219    220    220            
           2604    16466    products product_id    DEFAULT     z   ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);
 B   ALTER TABLE public.products ALTER COLUMN product_id DROP DEFAULT;
       public          postgres    false    226    225    226                       2604    16403    seller seller_id    DEFAULT     t   ALTER TABLE ONLY public.seller ALTER COLUMN seller_id SET DEFAULT nextval('public.seller_seller_id_seq'::regclass);
 ?   ALTER TABLE public.seller ALTER COLUMN seller_id DROP DEFAULT;
       public          postgres    false    216    215    216                       2604    16432     seller_address seller_address_id    DEFAULT     �   ALTER TABLE ONLY public.seller_address ALTER COLUMN seller_address_id SET DEFAULT nextval('public.seller_address_seller_address_id_seq'::regclass);
 O   ALTER TABLE public.seller_address ALTER COLUMN seller_address_id DROP DEFAULT;
       public          postgres    false    221    222    222            �          0    16470    ads 
   TABLE DATA           q   COPY public.ads (ad_id, title, product_id, seller_id, availability, bids_allowed, price, created_at) FROM stdin;
    public          postgres    false    228   �\       �          0    16490    bids 
   TABLE DATA           S   COPY public.bids (bid_id, ad_id, buyer_id, amount, status, created_at) FROM stdin;
    public          postgres    false    230   Kw       �          0    16411    buyer 
   TABLE DATA           P   COPY public.buyer (buyer_id, name, email, phone_number, created_at) FROM stdin;
    public          postgres    false    218   �x       �          0    16446    buyer_address 
   TABLE DATA           _   COPY public.buyer_address (buyer_address_id, buyer_id, city_id, address, zip_code) FROM stdin;
    public          postgres    false    224   ^�       �          0    16422    city 
   TABLE DATA           7   COPY public.city (city_id, name, location) FROM stdin;
    public          postgres    false    220   �       �          0    16463    products 
   TABLE DATA           Y   COPY public.products (product_id, brand, model, type, year, color, distance) FROM stdin;
    public          postgres    false    226   ��       �          0    16400    seller 
   TABLE DATA           R   COPY public.seller (seller_id, name, email, phone_number, created_at) FROM stdin;
    public          postgres    false    216   �       �          0    16429    seller_address 
   TABLE DATA           b   COPY public.seller_address (seller_address_id, seller_id, city_id, address, zip_code) FROM stdin;
    public          postgres    false    222   ��                 0    16833    spatial_ref_sys 
   TABLE DATA           X   COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
    public          postgres    false    232   ��       �           0    0    ads_ad_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.ads_ad_id_seq', 1, false);
          public          postgres    false    227            �           0    0    bids_bid_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.bids_bid_id_seq', 1, false);
          public          postgres    false    229            �           0    0 "   buyer_address_buyer_address_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.buyer_address_buyer_address_id_seq', 1, false);
          public          postgres    false    223            �           0    0    buyer_buyer_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.buyer_buyer_id_seq', 1, false);
          public          postgres    false    217            �           0    0    city_city_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.city_city_id_seq', 1, false);
          public          postgres    false    219            �           0    0    products_product_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);
          public          postgres    false    225            �           0    0 $   seller_address_seller_address_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.seller_address_seller_address_id_seq', 1, false);
          public          postgres    false    221            �           0    0    seller_seller_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.seller_seller_id_seq', 1, false);
          public          postgres    false    215            (           2606    16478    ads ads_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (ad_id);
 6   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_pkey;
       public            postgres    false    228            *           2606    16497    bids bids_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_pkey PRIMARY KEY (bid_id);
 8   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_pkey;
       public            postgres    false    230            $           2606    16451     buyer_address buyer_address_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.buyer_address
    ADD CONSTRAINT buyer_address_pkey PRIMARY KEY (buyer_address_id);
 J   ALTER TABLE ONLY public.buyer_address DROP CONSTRAINT buyer_address_pkey;
       public            postgres    false    224                       2606    16418    buyer buyer_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_email_key;
       public            postgres    false    218                       2606    16420    buyer buyer_phone_number_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_phone_number_key UNIQUE (phone_number);
 F   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_phone_number_key;
       public            postgres    false    218                       2606    16416    buyer buyer_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.buyer
    ADD CONSTRAINT buyer_pkey PRIMARY KEY (buyer_id);
 :   ALTER TABLE ONLY public.buyer DROP CONSTRAINT buyer_pkey;
       public            postgres    false    218                        2606    16427    city city_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);
 8   ALTER TABLE ONLY public.city DROP CONSTRAINT city_pkey;
       public            postgres    false    220            &           2606    16468    products products_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    226            "           2606    16434 "   seller_address seller_address_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.seller_address
    ADD CONSTRAINT seller_address_pkey PRIMARY KEY (seller_address_id);
 L   ALTER TABLE ONLY public.seller_address DROP CONSTRAINT seller_address_pkey;
       public            postgres    false    222                       2606    16407    seller seller_email_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_email_key UNIQUE (email);
 A   ALTER TABLE ONLY public.seller DROP CONSTRAINT seller_email_key;
       public            postgres    false    216                       2606    16409    seller seller_phone_number_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_phone_number_key UNIQUE (phone_number);
 H   ALTER TABLE ONLY public.seller DROP CONSTRAINT seller_phone_number_key;
       public            postgres    false    216                       2606    16405    seller seller_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_pkey PRIMARY KEY (seller_id);
 <   ALTER TABLE ONLY public.seller DROP CONSTRAINT seller_pkey;
       public            postgres    false    216            1           2606    16479    ads ads_product_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_product_id_fkey;
       public          postgres    false    226    228    4134            2           2606    16484    ads ads_seller_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.seller(seller_id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.ads DROP CONSTRAINT ads_seller_id_fkey;
       public          postgres    false    4120    216    228            3           2606    16498    bids bids_ad_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES public.seller(seller_id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_ad_id_fkey;
       public          postgres    false    4120    216    230            4           2606    16503    bids bids_buyer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT bids_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.buyer(buyer_id) ON DELETE CASCADE;
 A   ALTER TABLE ONLY public.bids DROP CONSTRAINT bids_buyer_id_fkey;
       public          postgres    false    4126    230    218            /           2606    16452 )   buyer_address buyer_address_buyer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.buyer_address
    ADD CONSTRAINT buyer_address_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.buyer(buyer_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.buyer_address DROP CONSTRAINT buyer_address_buyer_id_fkey;
       public          postgres    false    224    4126    218            0           2606    16457 (   buyer_address buyer_address_city_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.buyer_address
    ADD CONSTRAINT buyer_address_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id) ON DELETE RESTRICT;
 R   ALTER TABLE ONLY public.buyer_address DROP CONSTRAINT buyer_address_city_id_fkey;
       public          postgres    false    4128    220    224            -           2606    16440 *   seller_address seller_address_city_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.seller_address
    ADD CONSTRAINT seller_address_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id) ON DELETE RESTRICT;
 T   ALTER TABLE ONLY public.seller_address DROP CONSTRAINT seller_address_city_id_fkey;
       public          postgres    false    222    220    4128            .           2606    16435 ,   seller_address seller_address_seller_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.seller_address
    ADD CONSTRAINT seller_address_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.seller(seller_id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.seller_address DROP CONSTRAINT seller_address_seller_id_fkey;
       public          postgres    false    4120    216    222            �      x�u\ے�Ʈ}&��?0*6����ĩ�*��8ɓ_8'f��Rtq�����FS>Ijo[#Q�`aa=.�0/�k�?-�i�n�K1������O���i9����߱����e�u��{O��i�'���XL��T���6��O���|~S|��N�|�L�r��.������y<�������n�o[�?YUV�ɕO�+ܰs���y��q��x�%�w�/���r9]��8�w���t��o�օWr���/'�����2�O����x?�FZmA���ƷM���t�%��Wy��V�/�t���|�|Y~��~�������d��5��f�%�޹�*wm�k�����G��V�^_��L��6]N���|�y-ŉ��_�������鲌8��߅ֆ};��m����0���~.ӑL�20�H�~-�iOf×�	l�j�vR�f'�SY���5�j�7����6�[1������}8鐯|����w���I~��{9L��A/�;}���������F�R�N7��4����ꂛ�9Yqۤ�S�ٓ���7Mޒ�����G|����'zi9-tP/3����z��;���[�b^���ik��g�C���E��Og:����q~�7X�Sm����C|�1z�X�����f����f}��U9<U%����Ȼ�
�?�@�X���ߏӞ�B�r���^����]'��3D��/�a�#{��|Ѹ�e:O�#�y��q9��Y�3���cCa���C�7�Ċe�TE�vU�k�����+�H8��È�,&:{>��@`^8���V�/GZ���:�'��{o��+�d��O��z� (��WZ`_��h���pnW����C��F�w���F�.|�r��!�Z�b��6d���s�H�V��^'h a���0߯��̙k:q�!=��SY%�Q�+�|����3/�tWO�0��`e�%@�����x���mb���cla{�X6�O�������󉼔���2��w����v��mᶌ�m��2{{�Ff��	cX�!:�N�~+�nf&�E;��^Bz��_�W^��P��Wr2�5������^⧐�7�CX���sl�����ܹ���8]o�:l����(�5�ص8�Q���� ���_�=��G^`�-�"e��a(Դ�c��$.xb�L�n\"%d]�/3��[K�	�s�~W5���	���n?X8�$����;=������l�GɌ&&A1 ���}~��j'��x���e���8g�̈�1�@a�8f���f+�i]�j��$���1���0s�:
���eS�>ҏ� Nvm_5c-7��跢9��!����!5���(lZ @��&{.&
6��c�N&�?�H��lb#�9q �,
�oHW���23��W��Sͮ������V��R֔p��$9Z�-J�zW�9�2p<pq�/����V@��$#�Ҵ�v���y��6%����+��MAx��M��
�{�j�	��A�#��D��c�}�z�y�uٳ�a,Z7��2HW<
[�%�!�=ޙ��w{���F�O-Q������ב  $�O�D{2��:���=M�k����_�}�a≯�M���M�?򔀗�n����2;:�˒��͐��P&��u�J�c�ar4�5�e��HT�+9NӢ��+,��\�~*iQ]A~^w���ݖ]`�z��Dg|���!y�(B�H��eyF*�2�&F˴_c� �<e�@�N�t��X���4��Q����}'�C��W�?�X��	��u�?:����U�rB�@,�'W�6�����@��_�~�Ee���GY��8�s	ޓ�s=m	c�#�5P\9�,�^�{v���P/+  �V��i����8��@]�g��Rx:�e��A�Q�TkdV_;��4��"��+�z���PMQ�D�	���WS3����l�ȅ_xKJ#i	�#�@:�;G'��L�ޢ)m��h=����M1�$����*�%���&5�
y�%d����@L��
J,u"�x�/�9��f����ʰK o��]��N��5v���,�4�E@��V�|@IF2U)-
:���z#<��r3����|I�+B�48��[��	��l#���H1�)Tإ^Eu�()HoT�JB�Y(�5��fk���yu|�VDX�R�.`����ڗ�#l�Б<K-�����CV��^W>Uۂ�Y�d8���R4N�N�7���H��0�) ��sT^�0�8���:�C�V\5�TMN��;�j9[M�1g�k�u�{���C��-�(�LŎ�(8�Oԁ�B�� U�Z�6ªW���T�3M�seN��W�0K,p��UO�9���1��&���6�hD`}H'��&�Z� R��ƞ9�XY3&�;¤m���@��!p�t��Q����1��g�Pɨ*
u�`��ǆ
3-�\r�\u�,�0�rڇ�<c�K�A�N��x�/�e6���؂��jũhbDϿU�`F���6dQD��5hQ����P�nɂY^��7Q��>�7PZx�񊂞f���_yP�C��/z�ğ"�B!�R@=պX�D�"
ߔy͙�,�H�(�6���ciW�@[K�8yU%_Ŝ�G�mT` J5ծ���~�P�@E-��oԟ�f���g�� �s闈���` �m�Zu��g7�Çs�%��A�3��}���B�W��n��Ft���TT,5���RL�����i�����&W���H+V@D��q+�E�����"�i�cw�Y�C��)4��b���	o4<r�P�1�	�-�w����� 礬��KtY�@B�DG�fe�T�'%�����P�T���,��ԇ��]}E��˸DD�?Tk�C`�L�ۚ���}�Y�h�6����P���S��&k޴V�r1#6�.wG�@�/�F!?�H`�FL"�Q���i�^H�#�ASj+.��n���GK���BB�	��g���k��D���9���ʿK���^F���$ݯ�{Ǎ
bm5�H��T����+��`iI�`�Ncu����S��	�M9f�=��~̻�+��k�r*2ߝD	^ț�#��G_.���9�V)&��do����Px��E�����{Y%k��s��gx>�udb�j8�4 J
o�c+���s���4r�++q��s��s��!��Q�ȫ�F1�h:�V�f%��<f����__?
��'U�Vt=y���;ʊ1G���P��Q#�-�3iT9��c��_�Y'E��C�K�m�c0�=�1��\�t��V�n�&_���6'��cއH�Im*/-cl���>�e�p��F[�)�ll��~�q��+C���8"��Sm����]U��a����a���<���7�rf��S�j�m*<&���X�2HˆU�@��f����$K��|F����a��R��LMʎ��wM'��QE�=.~���?�u�wZ��,�Ot�#�\TD˹~�}R�w���Ay'�l%��fm�
0D�_wy�g�qHF��e��Y�$<�\�{�R��H �u����-Z���.B�c�)ܞ%N�dZ�+k�Li��eVF>7D=Q+� �RH��3C�d���={mL�E�M։̽YV��9�9���f��*-
@L1�A�u�M�0&MßU�Z�x�eM��B�����*��ii����<�E?�-3	��;4WJ�߲렧�"y_E����↢�i�:T��w�ɸ�)J �-��Qo�
�X|�R��կtY�����XK���#c��F�EʈGH)�'N�m}��#�g�|h���=r@�/D��:szT�R�Hh�6�@pM�MS����&n�V<P�߮]�����9���0&p��
��}���=�_��o>Z��^����7�4�ºx7�tb�s=�#?�f>Ů��u�ދ��va_��)b�ݧQ���"��a�yԜxe� �چ�4;�d}���3a@��������e/`�0����w��	��� �3$7F�݌Dm0]*�P�|�#�{�i�e�AZ�E{�<P81m�O��m�+VJ�|��:�K�+�gi���6o��O)��A���� �ḀIڒ�8V$�27����i9_�u�����(��L@ϩ�n [
  `�.�rk�~"?]9���b?4�!��C{u��d@�C�Y��Ÿ��j�f&�/�.Z�W���Qu�~D!®� �8KH��|�D�o��$7��G~U2�Ӥ��\��̤�ifȼ�d�,h�p�I���3SԲ�P����o�x�y�Ad�R�> �*?$[7� 	�[��e'��G@C��ɨdp����az#�e,�=����7�6jwohͤ\��� @����6�Rxv����s�]�rf��Lz�����ll=��'�v����ώ� 	�g�� ���s�K�f�ϸ��;�J��V��}��o��TC�9�*���]�ʎ�lH�*b�z*��Ϩ���m���,�#A$��B�T VYOS�fC'�L7U����.���xX��3�L�R�S�$��l�+����[Q&��i �s)�����$���f���g�o��Ů ��Ւʻ2Ŋ����r�wu���>�F�m<�i�e���[O���~�&�:͗�Z�ͣ�5��Xnux�-��&SBl L�^�n�j��(�"��	�%h�P<�F���,mРK�Le�52֮�)������VCh��-�6f
���l�J��,(����Z%4� p� �j0�wMz1�P�@2��:^$Q�R'�_��L6�
rؓ�]���4��&3����<o��XiO\�!Ǩ2u��<%���4�c��Ձ�6O�t}��z�t���i�K[)ӧ%�ĉ���y��3��u5��X��!úbV����G)á�Z���i�vF�G?w�#K3�i��]�`d#��8Nu+7OV7d�j`���e��^��֕rs2A��=��r+Q���U����
:QUr�vC�⌐���өJ�D�P�ƫK��U��ITR�2-i\޻�+�4��"q��Ų���!�Gx�9-Vz!j��@���z'��Zѐ*I?��+Z)s���J�kwe��U�,Y��g���s9%��ւ/z�W�`vd);\�.�T����U2�I
:���%RLY]��[];���(Mm�Qg��A%jk-���0Q�C���Myv�:E׏ܫ�pK��FK +�xy�y�S{�҆��vObitl2One�L���UIyꉻ�L)�gU'qb�hݔ-� �[�pf��Vmh�s�Qԝk��ə�ER���)��~:Ļ:V5�ŧh,Pk��H��ȣ��BEl�7�L@��� s�Ky��9�� K���ْX�.�ӟ�m��P߳;�}V��$5W���θa��'�J��+�6���Xև���+�F�02C�S4u��y.*X;�n$tX��~~��^sM�Ik���J���N����!���>�F{��m�gP�Z�*L�t^D��P~�Ğ�3U��p<�"�v�|\˃�<�G��L��P�N0$�W���9��OhK�����I�9�\�b�JWf+��jt�gM�S.b�2�:��M�O|~�5���mB�\+FK��G@���x
sgf(?�� *�Gj�Ka<�ot2*ݧ��IY8��x�d��bn�F��馄���E����i(��u��3��&nN�h?��e��B����%��w���q-�5��l�$UCJ4u�>�A#�/�W�DX�-mͷw�<�LJH:ō8��9^�����"���� �I�?4�-��c�E!N��3�t�"q����uz�gh�g�+Դ��E'L��H"�M�e|�PUO��|)S��9�PkU��HxK���!l�`AF�4���MAN�q:�-DK���ݵ�� M&?w�L�%$��cв�Ng����q�ws�R/Js�ur�26h��k�xH���T�T���D OIJz]����M�S��
�:	��aړ������$}h��Y_��YOL�	}3ə"�:���Z�^xM��J)|�ee|�W(�'3�d,$�0�+�c�O��6\��'�=���x����U�7��Pn�o9%V���������*<��B\�}�:���qo[	�{�ҕ�g \�V�>�������`-ߖ�'�f*����AE+�j%wn^����f�kmqq�)�W��m�W������M^r9%q�O�ѝ�@�ZL�4u�nL��"	�*e�>���Z�����l*R�y+
�An1����J�ߍ�X��|	��o���`��M�#B�,�ձ���ܴ�"���,L���<h�[�������ቘ�EF�oU���s�#Ĕl_�����}��:���Si�1�Du��'��{? /�[aT�Y5����Ĺ&e�E�}�|�ږ�d߯:d��87|;�>}��jn����đ�S҆�N�)Si��JL��r�)9��N�`�J��G��3�,�v�eq�-����6�bSF�(���HD=��d�de�\/���I/j��y�K-_���ٳo��Z4�=3�j4X�P2�&cz']����X��N2w+W���m:�(���9������$��+3�o�Zz�A� �Љ��Vϗq�m$���f����j3j:��꣝���,�[�_|$v�V���v3V�S\�ݎv�߮㻫RR�b��@ ^�!��e�2��u���hd"�k��U��X�v@x���8��Dr#��g�7$.��S���7r�W��g�Fb)�/�lw没��>�e����,�      �   r  x�m�;r�0�k�� =X<H
�H�6mڤ���Ky<c��
U����K�����'���{S��ô`��L A�������ǡ^�*���!�.�E��Y�2��I�<�ծ�5w�@����!��R�F�U��Y���M���^���6�U���戮�ږ,"���B��qVz��)�Zʬ�K�����/I�Qqn`�����L��>�;�l���4�x��{ ���a2���U���<t�G�h��l���g�~`��6������`C��EC�	aC��E���H�v\IZ�c?�r�8mc��f�5�W��-�vr4X{���pzv�+p�Yù��P�G��M��L�'��O����\�l�ZkZ�D      �      x��[َ#G�|N~E>JXp�QO�:�]#tK#h�/Y]T1��$�GJ_�fy��j-t��Pd�������9��f]�rh���ˮڔ�}/�s�;m���v�꿂��P9�/k�Cm�O�Q�,�Z�P�xgԝJS��;���>��k�J]��Ҭw;��՗�K��>xJ/M�U�s�Ω��~:����y�Y����"_��RƖ6��{[�p>_k���Y�pv�4Ǧ��=�վ�<�|�����u�y����A�4��t���W?6���}��4�c�D��K��k�R��K��[�Tks��K�P}��[j��l��#�}.��Bim���2>�VZ��x(�LX��msl������6�W_����柪����ΗMUZ_+w�#�H��c{h����C��t'���JƦKe5���RE?�9.��a.Z�ټ�شk���-v��3ݜ��pjH���pP��Nf�����`hP�a���c�p,�|Se<�1�����&���������Ӻ�Vќ��O��,�~�\1v4�l�>�A��(���[hx�
R���ةz�����K����ګ���d�x�pB[��{��t>�v6UKi[����e�S^z;؍�K/���
q4���t��pO����w��!�۠!����/��?���6����!=a漹��[zm��,΁��{�C�S����P�p>���j+�F��� O�87�~:>3�y�{[�X}���o��3����ys�@]�:�K3����>�S���?\��~��몿({���B����NY;�(x���t��6�'6��58aY��F�pmZ%c�h��
Υ�FU�4����������E~���]�S$�k߻���U�	�Z-������m�L>@��L�ʰq�R�	3�A�;e�c�opxöy�{�w'?o.��0ZAQM'3<��4_x1��#v{�=7��+��|�1bS�� 0��
�w8������-�uߞ���ӹ:A�Fqf4��lĪ�14]_�`�qa|���f��էf ���K���?�|�%�d�h&�^���yn��nW�Ԝ����>��"��6y�,�#�0�l��D�� �Ss�?���8�^?�d��&��S����f&�x�.���8_�2��X`TN��^��y��ZJΈ��9F	:-"�cӍ�+�Ec��Tz%s_��[XU}
�=2d�ME^����5�F�B.�	J��F/@���]����'��)�0�6�et �hLo�n�q��8dM������q�q�(�S��_�� ,�牮�\(��,�����B ^M�i
9��W����upc���Q�9���y���v�񣿽Z;��m4�$� �����7���x�n8�L)���:�Ɂu�<��cC��%6u�	��|k��\<�%��F�^!V���v�����f#�Z��s�
{�E*n?����X��x��&`�{��<�A��"=�p�A�Uq6a�Jp�	PYF�'A��8�#�8��}YZ�+7���Φκز|-!4_�N1&���:��g�L��E�}�rrD���9�`*�`�t�������v��;h��ąn�o�8k��ӫ�0w��x�8�1��ɶ�}<y%����/�.8�-��R5���M���$��"Dxeà��'�Mޏ� �@?�1���l�C�@��M;�n�c-Mʱ�O�֣%�������q����:97mq�S��c�� �<�\8�![X�be�oQ6 ������R�1#��b��
'k�/%ۈ���9N���hS�#y0Z�/���p	\d���g�JC�yC�I�"�Ь7t&ڥ�i���< d&��Pi�Κe��o���q���X꯫������7Չ�O�9����Zv�A�a#����w�U]��C���+��.2�!�pj��,C3�Ͱ �x��#0�ެ_��uձ,<��ܫ�!z8`6CXah�ԯ����w0�5L���"�: v�t{L��6�Y�M���@j����q���������h��E��� �2}#�8���-��=����ܳ�}/�6LH�p����ǜ,Έ,d#>T?�au�7��,l{������2/Yg -|����}7C�� e�k�:-�����,�03'����H/��Q8���V1�e��e��2���.W�5�Ec��(���lD1�K��P\B.v����,���1U��N�=��.�+���`HN�4RR-�Z�eAW_�݊���q��Ћ��� [�#d�K�Ɯ�Ip�wЄ��zo���<u-���K�a�V�I��H��؊��"�=H��d�P�.�9�z dR��F�{1j���a�v-F��:)�{�6�8���zf��(��X�_�
\���OH%��c�jQ���]UHr�����[ �~��k��X�׃(�������'��BЋ����m��_=M9��a�O��q�`�v{��Ȱ�T̠vp��7pHk{n�#�
g���O,b�wy	�iFj��	�r��P��Lǈ�L�Ո�Tʓ����ʩ'���.��J}��r�5R#�ҍf���h2��&�!��BJu_�2	)���e���ik�cE�ф�z�Ff�R���T?
��ƅ���\�۰~�<�2�b��"��?+��,��u�	�s/̱*M�=JJ
7@�pn� %��������e\Z�R�))��5��cђ<�#���eص���5�>��@�n�X:�d���+���jj��/ͩ:RZᖭ�[{U����a4�Pg������a}>�~�s�"��'F�gk���cS�-(U��Ȯf%Zd�8T�z?ܘ@��/�ƒ����ߝ;��|��<S�g�w[��tor0��p��4�o����%ݧ���C����{[0@�>�R�5� !�Ux������"�(hoB�c��Z��1|d(��ۧ����;��Ŧ�n�N������I�K�H�8��OM��ͩ�Ԓ�(����4��XU�0�#˂�&N��X�E�TR��>8(+�~�Jώm��%�F�Ů�B��'GmVR �燌�1�ں��B�����B^
 �ŽS�����zXx%�	�K��PB(��)V��e���[謹D��ʞ��0X�x���4�H�߷���o��J��ȅf�o���pc@�PeeLbiXA������pM��Z�����z3ԫɧ���YKZ 3ޭ���@��:�XěĄ=������5>�9f�5�a�tތ	�J�ۆh�6�|��V\&[98 �ʡy�=��?Xxh�}�_�xs�:њ4{$:�v΂5�G˶d�c'B�١q�2[jp���H'X�c�e���yCpq��I�[�a�m�����|�SؒL�0J�!�X~�'f֑P'�H���X�dZ�j�� �<�#�c/�����7�M�/��/L'���?��f!��y��~�
t|&Y�lM�F��l)(#����o����+V6�A�Q���dt˨b��138�"#m	�}Hn���>*_b���؍K��ʁI�������\��n�&��M7�b��kB3~?"!�
�#��J#>om�'Y��+*д�bv��1������ree���q�#�6_��4AC�w��%��.��@���1�y[{��Υz��ѥ~��/��VR�=Ů��3g��N��h�>��h��ك7b����f�_k�fت�ʌa���:Y9�
�=���@0:
=������]���y�!�$�����[:rH�E�cPN��JǑ�xfM�4;m��~~xav����"�0�䤥���LQ
'5Lx��շ�iU���v�\���ū��t��@�qs#P"�%����ϰ��fh�v"����
��2G���E?�
n(Q�����YJ�%菔�E��f��j�2!똊$����!�^4���ed�2�����ΞyGL�}IHb_3�w�'���3Bw�0�[�=#B��	dǜJZ����
��I����@��H�!���I�4�5SZ��6��M�М���Q�!<��HH����L�	/�=�9x2Ҥ��P��a?�^���[V |
  ܃�fi)�eǾ�|q��!L%]J�����f�E�G�a��C\��2�s��\�<�.����`��.S��J��`H�?���1tq�q��Q~��-�kA��j	A\&0@МZhìf�����n_�!oq�q���cF�%)������2P�q_����ϵ1�����ӥ*��3 H"�EW�Q��>�pi`;6����@8�B7����l�m�wA��IY�k\����EX}�-�R."q� �o�Gz4@�(&�P�co/���Ð��ZRز��r���Z=��*�F� ܦ�9�e�j�L�d���o�T��{�G�6�E1��"5�g�9�2��H�e����e�n)O�{�	#�n�h��X8�']Ն��R+�Qo��x^��+SG;R���+�7��	,6�Nđ<��4�B���{�wƬ�)x=��K4�2��M�Ж6�~ő-H�"�T�-#58��C�Ȉ���"�A��È�޶��X-�����2�9��J%$�0kp�N*��CW�gda?���BE��Y��yR�!��i������{��k�����^��)�T�h�9��ۏM�է�y���崰o3��@�Ɂ����u���j�+fC��͐9z�y�S��.�-t׆����;G�����B"DD�e�R'E�\vAkO�����4n�<ZϬ��1�h%Fp,�RmS?e�ͧl�q��!Y��r�av�|@RY��[�/߭����]���	cJ;^!s��x<7�x���;v��6� t/�H7;ڠ�(��X`Iod"�����=����0.p�P-�l�bJ��|���X�R��T��φb��ϐ4�%�`���1KҤ�㫝���R����+E�U,���Ϥ�B����e:N��<Ͱ)}f��=��i̔�{-�DS�����N�����=���Z`�v`�<(��v�"��	�.T����%��OI\v+\����-<��sqR!`��?M��\����U@
_��Q�)�b^�87�XO;n8Sy�!�?UG��^�����6���I���"��L���Q��H/ܪ6�ep��q���'��0
�����q�laP���F`q�#[�yd��V��}r���˹d��}����|�Y�V2�4N�q������9��=�$y��5>Z�F���5�50:@����C� �@��a ��
�2�-�$N��2[��9roF��!�f ���ӎ+v��O���1xx�g����*�ne`��s3+���ťgLI�2)I2[�}`tn��:���ae�$W��\ɕm�S[\�'t,�kϚ���\rڿ�p�hgrn��<܈/�Y�碙T���2�v�)��54�}�h�|2ȼ���Oy0��g�>W_� ��7@���T(=�6
$v�-�;��q�T�LJG���_� uE�ɩ��l��3��{��V0(�f+�qX�y�U�7�'�j|���H0�L�rDS}�'�W�qJ���f��E����>���~$�`�+j��]��~\���$3ɢu��T �MJ猌��Yթ�XDS��;·:��9����ԁ;�3PF>��	+�����Wz�N�0�텃��]�,3�b��X>Csܗ߷��m�>���a<�@����RgH�Fā�\��T��f�q����aO�@H�� �v�`w����Q�j��ċFf�3ZIQ�ؗ鳁ҕy5�Q�n�G�R���P�)���)�A�a��\��q���)^��$r�xK����v�"���Qږ�v*�rB,J{M�"��#>W�$5�tS(b>ʉ"\�#1��e���*b�����/[o!��ٌ�I�����]�&��ϛͪ4 \"͵둞1 �ҕ+v'<7��k�g^ԋ����V�)�ND�LL���^ڣY�jL���u��W�1~��+C�lA��.�&�
�E�������IV�ǅ(�9�p�'6�$�� �b�������]{�����kn�){���*�\�J*mS�-W�u��秡,|��W<�����b���V��E��tR#����e�S�vQ��~��S�xY��;I���a{y��m�[l�Q��|ӚӞ�k0�l�{��.��BfL҇>i��fT���g���Z�2�!�)�>#fB%%fBgo�bW�r������"����鴋J?�v�D��8�\"��B�4ȯeH���gA�Bo�Ӌ����[2�<(�T+��BQ��^�0')R?*y�vA�ާ:�/q�P,I�11�<���b��g��,K8��Y�󓍓�����d�'y@�B5o(m�0��t_�=�!u�
���k�rO�D^.�J��IO$�!��eVՏ�����i���̣�tr�ό�i�h"H���e=����+��J�ng�4J�<�yG��@�WO��g#��gf�4��/_�!)S��lh���T�,%�ϔ?��_Ev�BD�6Tb����쪟_v[yLR�ۉ8(�2}拖SV�k��*�J�<��툀%/���uS@u��Kd&$���m.yl����X�����l�(^�a�Ko����*�0\�[D�vJ���4�f�.S�N��DV�
��ryN���m�l9�ʤ���9m�pڬ�ht|�LēVe��hА���A�y�+�p٤lY��s,:,�Rc�aH��Ð ]�8���`�CˉY�8IW������ m0�,      �      x��Z�n�8ּ���_`��\��"�8�ψ�� 7�-��e�[0��_��(�����E��:UE�K���o���C}<�����y�N��_����<��o�qWh�,+E�g%����_n������ku>�cn��������R���(����[un�׾C��y��^�ө�����M�9F|���q�=�v�{՝�sF1�����z{h����U�f����˛��΅��R����f߼cMx���w�yl}Wh+�,M!m^�5����}���nU!����w����^}��U��?V�q���<�#~ǧ��g���R�H\���׫���f��~5�02��#$ձP�{V��{,N[C��z�Z�q�?��k���B{�t�Y�h'*�rWo[,cs���+C���#���@�����ٞ6���H�Q��s��
k-s%�V%C�}�wu���S�Ǐ�}i��x�?FH�KNV��@�z��M<֘4?��Ͷ���m����p�s̊ 2cb���OծF�cyCP�q�{����ڒ�����S�Z�U�h|X$��>`z�R̃�Q2��zLC��1{~k�����P[�0�s����������7g*	�5b���Y0?w�y��?���1G֨�D�"�܅5�!i1�K���~؜b8������B*&m)6��*�~>T�͟ձq�[�qԥ�H^�!�5�����^b��ɾ��NmȉR��rWc~଑��>nKk+�0Z�BRD�z��� ���7b�*��RE�!��zD�u��c<?�oPZ��V�	3i����N�',�52�L[k�c89E��@RM�A�\=�ӹ	Ҥkhׅp8�R ?�Ȃr���|�yl��t�Y�����+��]��L�?l6�&Ar��?(�pN�#b2LL�0�E���QǊ2��,dQ(��t}n���9>�����֔�aRq ��_�dw����/�+d�y= �~a&�=/%Ce����2�
�6d��}E^����\�Î���t�b�T�B�I{^�Z{�~D�1V��eL�R��1Q\�͏z�}��g�S�Dsui���#�OPyԷ��Sb�����,to�-%� O];�ƫ��ഷ����ĝ���/OF~�oU��[7,H:�+FOg-�㶫vM7�#�G���`�VaeZ'��6��a�n�£�W�T"l'�Up�'���{k+�t�ӹ_?m�=��9�������s6�CwY;y@>�%|������J����R`DD�X旨�� [fЅZ��Ӱ[�޿��Mc��P�]s�"��T66ɱ�����B��XP�+�������ޛ�O�6�X��X�~IP�5�Y��l �(��+5*�'���{���P&թ�B��
T�H�q������m�x���|W~�!�\Q#�-�Ԩ������_�
���K�N�ԥ��)U赫��)����>���H�1P�	��Tؘ���N�ҁ�r|��[ ���+i��u@^9�Jm4K9���	��4��,�M��	�Dc�Gg��5�����_פr�txw��m[x�����O��3H�b�?R;0BQ��.�K?(��.�{��>e���xWQ�=�Q�CQ��>��Q<N�����j�����4��K(���։.�
Yg�^����B#J��� ��~�ω�~�o��R��!@PV#��y��k��.�}�
��$!��S��SB�t�-��� �ZS�1ħw�W-�֋-�E��	�� {�����������ݴ���CП��G�V9�:�B�D�5��A��$C�����[4d�Tb1:c㢂Hb�P�i Y��$lo�t��C�0,�$u�`?u�����l_�$�ūiӏ=P�?m�8����y9���x�`_N��{���s�z������R��!In̘K5�wd�
rq"֯$�heҌM���rR#��#�O�p��3�J:4�����0V�V���U?�AsK'�����Ȟ�ϵ��6%'��!�`O�h�#��c��D9��W؈
�y$^��~���ה%F/KĊ�o�A�"�]C��t&0�XP����+4T��A�I$�4q��(�W��ğ�k}�߀�	@�s!�b�$p3����é���Z�*ck��6I�BցUyнL@,�Yy�%�%�S�.�1�_7טo?����3�-Q���dY����(�)=��܎��@OY� �$m	���H��oG~�vh�q�����v��~��:
�� �NR�@�P M<�@k���&�A�5�*�#rD���^
Zn�Ĝp%BϣX��	0�G���xh���� �%��W����>�Ⱦy}�����%'�!&!7�dd��I��d��u���n�:�*�$�`d�Y�Y�y�E�m-�)A��l����0�3��TA���NIϩ����{�Zw�%�ac�e括.���:�ѡ����mV}kQ�t�T%�!)P�+>7v"���X<��3:��]-8�OM"����J���$x�ڢ|�zP�#P�\��O��r.��P��z�j.�����,�����C-'^��L�M�g֍bq�n�Pf�L���=�P/��-2�'Ș`y1N]X|x��.�s��@TcFY�!K�[:c�wW_7��	Z1�/ 0Djx�c�(�6�IүC�s~6�x�iJ�H�Qï���D�*dl{l�`����D�Lp��"�Ϊ���ͱ���hr:�~MFͥz���X!�bF���,AD�$�[1��P�7�6A6�2���e�l_qv���_���`:A�v�VF�y3��|���.��*'�*G;Z0�Q�Г&�W��j�Ue���Q BV��z�J&��9��P8$nf�P����%@;���h莶�������w
�d�X�̦_ ����Ƴ(_Iy>Y�k���&��`[(�ٟ��/����;�2O��ɬ��^�rWCj>��#�֊g��f[��#�#6`kD�d�xn�}H��[�AB�m��c����H΋�+2͔�3V~��/��]h?�pt2�G�Z�U��؏ ��N�Gk`V����c̀'(:����]-��Xq�-�S�m�2�AiևB&	�69_e�J��I5(�6���0����9�ɦk@�9M�9!})?��d��l,/=��[>������]��t�%���N؍RGIf��ƃ�	�+�7)��׆J��F��f�
��z�Sѣ�F�`9u^:�6/ǼFm����2#a��f(t�<�&�?)3�b��QJ@)�9M"f�X�@ֱ#�u)<�	`�;3ٖ8��1����t��&v4������X%Ã�>Ѣ�OK�����&ܿ����g�� rn��d����n�}��`)�k$ѹ�/,.�4��f�ڞ�b$���]+˄�ǜ[OWc0���šg����M��@�hC2�Bu��<y}xj�� n�'���Z%g��`�%qq�Y���_HK$m�΍�.����M�ѓU8p(9\;��Pٕ�JC�ZM�Y�T0��,�g
���x�@A�u}�)_�v�Q��zZ抝��A�I2��I�AXn���^�2E��Y���tp����>�PAXY1\�*�����9��p!S�+F\��Bxc�a��qu�u���rR3t2�f�3I>�X̞�ޑ�&��{��[��h�F;��ƾTݶA�K����}HVЄ.(�q��wzc1��t����6�$����Ɔ��QI�r����mz���н��Jg�������2͑���0��ja�#�<s�rJ���b�]�H)�,x���j��
�C0DvپΈ�9j�:�]��"+�����r�H@�N"3S�=��,5T���:�#�`�+��0�(|��g)_]̆�Ú���F"�2��\���Ǒ>-�-�;;�?Uglԓ� �_Sȕ�W�~�V��8��{7��#�)��5^�ё��޼vO'�W((y?22�[�9�!�jK9A3��e>�!�Μ���f�������5 ��tE֖��g�gS�;�!�'3�������\Ӈ'��ke�z��YrS���;���;_\i!�x�:��
X`���Y��rKr �  A��� JF]�-�m.z�/35}+1�!�j��1	�u�P����7BL�q�yy�tc3��ӊ�u
樘�c��d2,B�7f&`��#�����{�(���M�%1���j")r���e�a�o�| ~5�\BL��6�'=���.,\}�N�5��O���XRi��1
�@*���̱��.NQ�"�5�mDv6v�4J����Ĥs�+JK��>w-�H`�>m�!�2Z�)*���q:~�9�okN�Z�ʓ�q����g��ٙ���e4�b�k���e}|�H_9ʅAIӎ�A��lGu�FX�	'�'�tԘ��}�aԇ�}�c��+q4�+�I7��Y�_3�M�A�,���l�<~�L�H�����%�r#���x���\�~706m-!	ٟ�;��$+q���N�3�˟WeY�?%�֠      �   i  x�U�Mk�@�s�+z������~\��A�=z����F�����M"�%��y�n�|^zy���t��7�_��z��˕7��~Q|�߽t2��+�N�|�z�Dv�N��g�;���v��3'k��r��|5硛x��)s��q�<���I�Z�����rL��+.�n7t�'we G)f�1��m����K}3dk�R�V�y*�����㭮��B�S
4���~ju$�e�˕5��^~=��oںn&�s��e>���D]˩9^�Zz-
C���6�Kb*z�杜�k�}y�`@��wf[�H�*<�n���Mr����%���ߢ����~h�2Y6�h��U4�=��_SU�?��~      �   o  x����n�@����������%%�P�T�$�A��2����<}Ϙbc�� ��s�w^�CQ!9��T{�b�\/p��z!L�'jg�W2p]w$�T3]�5�5��	�b��
b�DH+!\xIK\;;,ua(�-̯��l��M%�Ue Y����=7,��C�����$6��gک4��#x�5D�~���^y^���0?1+r*�#���s��ӻ3��S����;@�s�ĝ)���u�}����%y���X����3>l�fA�?��&�U��Yy�IK���
��A˖ܒ�.4�*)���A�\��	��yMKU�a��N���Ɔ�(��$��o��7��<kʑV"�g�ϰ!�;���	*����\!��8���p׬�>7\�M�MF��� ���*�f�b$Od���t���ٷ����L������y�㱻�[��E�4���}����i�Pia��OK`��ltR�-�������1Ks�K�F7�Q�.p�-���[�4%�ypx^��
���FB��'�Zv͎�&K����k����#�!�o|���a1y�v�l��7�V�0�G�Q��<�����T8�hP�;x42�=s�� "��5Q p-��H��e4�����      �      x�}[ْǱ}n|E?Jq��<���k�"E��vܗbH�`5M�������:L��1��̓'��շͱݶ��m��l6��s�,+�~�ϫ�y۴�?}�o����_�ʨ�G�*���k37�V~��©�����7������=�w��w��;�f��	f���'��A���\a�T��f���V��l�c���f�wM��>s�A����믜	_�����qO5W~n2N��aa�����C{|��y�˩������6��:)םO�u��^���i�7��~Y>���|9�U�k�8y�����
ƖTqnlm�B�`���<_���.��9b��_:��/�j���2�)έ�����ln.��f��[��jVe��[���N���-��kU�R㾩Vn�ϗ��6���o�s=\`3{ȫA�� N	m8U��Zl���%j#W��mꟛm�lv՚ұW�}��K_�:���3?�������iU��x:4��k��vU��s'߼`P��������ٌZx�Pn�u��Y������m�q��ȧN��.41�.͝N�������i�.���=ジ*~_�s�h����ɦ�Z�aa���i[��9n������ܜ�՚�A�s�����ܹ�;s�Bm�ª�Ş���Y7����V\=Aؖ�W�&j������v���h'ia2�V{8���͚�r����g���^N�X�����i>�v�Lz՛Ӧ}jv����9o�fe���������~V����㟝�힎��U1 ֮_y.�ga6��.�Й��T�V�˧�S1��l�3��[8�����`�ֺѺu��X���t��]p68�R�(����h�N��:��vp@ص�iǙQ�w�g�Ԟa8���T~޹o�]���T�U��(�R�gF�ր���p����5�y�l��g�СC��kf�T� G�	����О/���R=�a��t2LG���4x�?A� f���n!k'+W�5�yO��ӹ�H���U�	g�,߭����gb�O�޷�0}Ĥ \ɺy
Nw���#���ya���
~r�뿶t�f[�>+�F�<���cJq�kE�v��̄�f�]��sSkڣ���耄o�st�I3��	�3�+�C���<��O��C��i��  T�a;��	��xB���{����Me�s�o��G��ij�to�QL�0{h$�W/�#�(���[8�θ-h6�W���&�%�ja���a�,z�̽���,}Vn���-M�uΡ�ƌ<���fV��#`����8v�"�\�y��@��S�p�Y=���tV��r��4�Q�C�&Q*°���9� �t�LW����+n���y(k��f�we<,=�g�Y/j�x� ���-���KXX��*ҍ���g� Y7F��<�r|�\��=~w�w����ځ̆X
� �����"ĕ�=A��m����V��A+P��2"8R�{#>wj@� ���z.������B!C	~�l�P/���W�4}{���������N@�l����[��=���香) Ob.@h$�jriI���|n�`y��4	 �s�X���׸
��#���k<����Y�B���L�G'U��fn@^�2�ސ2tjX�S��\:�S$;�%��,��13ga"Tr�ea[O���8���9x_;<Z��N1m��͜x�Y2��tٝ�5�ɵӸtǽ<��R�hJ����`����{`�n	�����
):�F;A�<�g a�ؙ���47����/�:�!�U����>���?#S?Q|���O�\	�e{�p��|i�MH�!6Q��^�0i0B�~e�`���E�^��`@�eC�B�;�Ͻx{��Bm��}O0��og^U6�4����I�S��;����yxN�k�Q#^3�"�}h�0�#��y*�Dɀ̈́��[�v�M ~iN�vڵ�$Pډ0u��Y����Q$_g�@>̼dM~�.b�w�����
#ğ�!��*A���ٱ$`\��m��6&v�B����An�}�������I~��x�W�ʅ��ȆG'.�-lb��C�a�y\��q"P�Ku�x��uUB�N�,G4��q%?��zA��@qp�J�����>�%�vL=P3�����#}�Z�������-��������$�9�qĳD�����]ֈC��7�����,ݣR�@6a Fy�Y3�� ��E������Ձ��</���l0�i-#
�)��P܄Ժ/�����|��nJ5X��~��u`��B�������~}n�S�H]��bj��Lj������y�e�~�-���;: �.���Ez��y���\����!��0�����\��\�r�{k��%���I�ⵔ�"kS*�s�mϰO@}�mǰE�K}�Z�t��ڒ�#��$(-�� @���y�Wvea�B�sR���z>�����'�����бừ�1��\b�1�d���HƘ���"H}d]VV��Y/���N�K�ķ�P\$�V���w\ٍ�E?�&�J61���BX�1�H� �A�Z��:tK�~��73.xJޅ!^� $�֜���qy|܍���W�CFf����X�,y��<���`?�,�H77f��c�R@7Z�(C���F�}h��Ul�*)o�8�DD3�iIE��C��| )� �˶P�'ȻA��l��;dL΍�)���͢�� ��5G�"i7K":�;�ɁU]Н�]���'��� /�7��P�@�G��A�1��Я�Z0V������©��0�$�skKZh�dR��,����o/���SSu%�m��	���3��MCT�9����c;��	Bo%ẅ́�p>�� پ���t ܠaZ͒��g�cA+�C���P7p�(~������~DvwӴ�!M�;�&��y�A��C��4?�߰�������A��v��+�q@�X�]��È�֖\�%���P`"��`�ա�n|�! �F�n��1)�4 �Hn���;���j��<�]�`����,����q�r����F�]'��;S��j����e$�q��a/����UB�)�r�O�?b`������EU	3CT�Rb��e�eA��>�7�]��ԉ��$G�u�>{ZF);K�(�||�*���#.�N��ʖOL
�L_�#���s��-r1֕NkF��E��"L�Čzб�*H�K��� �����a�O�E|�)a���?��ƅ�*v���e]HĘ�S�������E<��hƊ��{}�e��n��wŶO�7�8�^�c��LJ �X����{�0���Q!����P�"�� X3�q����h*�,$����~83y�N�he��-�l�4�̑YQ0C��xhh�@����v��� ��D	��<9�����F��=��D�eb��"��N��b��9&�ȇ
؀��H|x��޹�u/ͪ�X��A�y�i�@�2cVKg ]���ی ���ç9�cy�ȕaԠr@"V2�G�y���l^�"�Ճ�)�$��;�JU?�x��#�jOq�IӲ&qf�Y��IhJ�5c7=��PV�`v(��% 0�u���CcA�](�@m{U�B^���v3�q֚��rc+6������˅]'�֓��d�:"i����\�3�f`KGJ�l	 ����e:���-�����������!���+m�Dl�*B_�eVa���v?��?�G �	h������y�Tm�E��`+��ߺ��+_�
��K�kY�W2\I�5R�%v�c��	����	35���|�+Y8p��P�ɼ+�|"��
ī�<_Y���+�݂������a�?�t<�GW��Ox����� j@^�q�0%!^�׺�i}&v���C�v�M	Q���.�,.0cf���R ��򖀵lK�e[�i`��A,O���lY��΂.l.g�����dҮӨ���	6y�t�-���I~k�K���I��ҩ��H�.IR�����=���\G�7"����JX�L����F	v�
�R�i	웉f��	7}2kqN~�JϱLK�yX �
  6�ߚϏ~��e&lXrW$.95^<1s��l�J�!��|xW�΍_����`p�j��[���]g���,��F~�7Fa�8�S����j��F�V��<N�E~e���YUn�,��N0�����[>��X2��P��a��B�#_,	�,��1cQq��k�Ø��$=;�F�%���B��c���'�ViΗҷ�*����4���+����Pf��$���!`��=��%�?Y:+�U�X����G"��2M�Ũ��"p����nH{��cZ@p�4{���G�����U�^�쏤�Z-��-9��Өګ�FՎI�+)sA�h@��ɾ����$<*�^+���٬z�Q����-�f�I/�ZZ��bA�4I�@�}��S�g;侚�ɾ����U՛�����"�t_(I�_���E!�r�hA/|�?zj5"��ͳl��չ/rȐ3~-�H�����v̪O"��껡�d�A)��)}	� ���������vʣ~�{:��쟲*�H'�1�~ǌ�bG��d�ň���,i �E�p}ˎ4/���	)��2�9������u����2}�~6j�O{&�P\8g�h??6�SIE�q�&z��4wc�2Kzĉ$��p��� ^,���\�{��9�y�p�}��K�!�堔��y9��a�aE�|�:��J/�m�WC\��>]ౠh-��/�gX�7į��X��)̝Ə|7�	�&�@�|K�����w��+a�!o��fGK��C�y�$��ף�,]L��,-�h�p[%�g��'�������z�,�nX^ �q�U�P +���ְ���:f=��A�W����e�)�.�4r+�?
�8�z�Y��5�v����ogMa�6����Xl1҆u��5�ߜ��A��9���UM��P�V����ƫg��*O�b�@�(���y~��<O+$�$�T��s +l'I�F�"��Cd5��y� V(E�QFD��t��Fa���ϓ��#�����J��qjșxo9M���Z�k���8���}��(]�.��KAv:�,j�'�O�:Hf`9�3�l�7�/�5N"��/P�%����v��%i)�����'��T��BDD>u�T'Rd�P�KWE�@�v2䨽Z ��Ү�i��Q�S��W�C�ڙr�ۼe��^�gJ���oY�+K�n垊1+�a�J}_ݐ�-��-QĻ�Ͳ=�\��Yx�n�h+���(Iaw23�J^B�m+E��9�!�k�W�}�y��$,���P�������}�u�X6��%*��.R%������Տ��n��:������}m�=8C߂.%<��5�w�����}W��,�_;���}f�;l�%Fv�%P� "HJ��p�z�'N �G�`��k����&e����Oc��t��P�;iP�6Fһ��>7q�����' �j>�cY��|&���5yؕ5GGv�T0w����=�_�P~�~����bj��)�﷏����̔n[�V�;�cs�+isU�P���y8����M�nl~�-^��$�S�.ˏ ����:�����`\�?�\��N�a�$ ��X��Rsu����!��;���G~�Q=B8��7�!�vJ�Lh?$GØ��rb��Ǉ�~Sf�>�w7~6�(KcVρ�y0KS�>�|�R��L�:{�ia��F�t{С�]d���Vr����0�]>Bx��"J�8H���uaKh��/�h7��W��P֫�<vJ����>�eyv��1YJ���҄��l"}��Z��*�aK2x+�^("�o6>�6�VZ�_���PJs�s?M�y'�i�����1;���eW�Eڊ0ъ!�ΐ7��btQ,rLGGW���3��)~a<+�X��^\�JNdhT�t�ᴿw�{-B!��V̯� 	��>�"p�w@.}���Z�>���=i� Z�-i=����Z���2<1��m��UW[�o s)��2V~d�5s&@�T�D�D���m��a�2��G�*�<�Kj#���p�.x�V�~�M+:���9��嘚�r�Խ�*c=JsF��ir����1�|�X��o�}[h(x���P�q��d�͌����Q�� ~�5�&��0��^ش2���8�y}3��[�}�q�%��o���g^�h�Y2���@��m7�Z���O���|B;Ω�~I��gϜ>[�-���|�Ȧq�D�t5!YV�
�����%Hy���e�O��:�v�njXa�>vN���$)_9���n��Ṉ7�L2�|@����Е��}ZJջ�L��m'b����m2?|աO���0~%!����fpƍw�݊t�v�*����9L��Y*#��o����W����}?BE�)_�2���W2i�q��d �Ҫ���$�����'1���R�l��Ͷ�D	��>Q��2�Pj���J�= �����r�F�W�5H&=[�d���-�2��O�h����`���ꕁ7v�l���v,L�Ð�{Iyص�.�����ɘԇ��'��:��8Q"�PɄ��+�3�����9�6������?I�<��Z��]����^ƶ���8��PAP�W� �<#uX�|_ݷ�����u{��Q�87&��Y�!e�%Є_���^���l���}�q|�$�~0Ͳ��!K��%�-�5�$o@�	p�(��>��xƏ�%|���g����l���E��      �      x��Zێ�8�}���?p
��|�� 5Ig&H�FyQ�5.Ŷd�����E�(�I�JPiQ$7�^k�M�L&ӲP�����o�+�������T����<f��s�9�9S�����q���X6�͌���/��ߕ�n�>UM�k�6>�6OU������MV�Lj��O���r��1��_�����we捗&��KG|xܼ:���}y�/� l�m.5��ϴ���.�����{l���o�?w��yc1ˇ�_m��|��s�7����l7��9��C��?��s����6_��l�`�9��g���j.�l���q�6h��ڗ�c��R�!�X�η��������-n�[5��\v�+|(r)2i;�TM���jvC̥UZ�����6�m>������J	os�Ώ����h�����x�1R�W����Ͷ+wuW�ǝ�q�v�x[�9��4�r��c`����8�YOz.�>+�V�6\�b"�ߕݶ�V^�Y��6q���aY�@�l�}�lq,��x*��s���4��$�(b_�[���ڵ���\_��+��T�u���gW#VN�\���#���_��v�|9�{
Ȅw�
���f���e�l#d���o�ej�!W8vm���|��=u�eDH�y������c6i͐�#r���8���zd��9a���H��8�PV��0�g����=Rl��d^c��բ ���q�,�����8�(�8�)G`�B�G\Q�\>Ȼ
�Rl�X�n��Ց)l
B����)/\�$�w����BB|�%&Oq�����aVy��?��g�Q���~󱬎����C�ό	'"����<���t5�|��79��I$�$��?�������0�\��3�E���QS�	�ν�w�VYQ$������R�z%��9�h���i>2�l�Ʌ5���1#���P�a���'��ޕPg�j�LN�vó:x2�	Q�JX��97
`�ɛ�x���,�ߗ���&�B���GP�������qr)�
:Ř;���/�ǲ��6���S�l��-V@��X b@&�Ù0^� �H>V��|n_UL�����Ia�\Y#�#q܇������,��鼽�Z)�\n���-t?�}��&��|�9�7�7&�q��e&.�Su$�ΐ�LX�r�|J�?�zo����ͥ�D
Znn�1eRz�}o�U�ǵ����"b�����_�c�eRx�5��2�{�xC,u�3<��ÀF3r�	-��&����Կ<�
���wm�	ۑ�)��Fʶ܊�N��^=o���c_��i���:>���&�h�K��CE��}���͑�^&d�`�5�dhZ��
c�( d�@���X����{4-.*1����G,�H琪��4�@x<sD�PTk3?�������CMZ��[�6��/ԇ�;�[Z"n 9�hL��>D�R.��e��H�M�<A������O���`<lPn�J�qq^D��b7�~�����G�$l�/��x!�=��+����bc�b�pX�/�\v�Q��V	/;�����'�������No�C�k��8m`��z��s2_mfF���ÏK��e���2��-��q�����m�z��k�n���,?�x'���	il1�OC�$����*�"3	-���J�	�6��J�^�/qߌ�x�pߕ��o��ۣRZ�L�B�L��	����������Fɉ��4J$�|UnY�+��h���]�~U-Z[��ՂK�����O%��9f6n �!D7�b�������b^ڏ8�\�E���k ��p�ȭ3߁�_oۮ���,JI�-�W��bru�*H�lS��ؾ:_�ޯ����M�&��a;���?�B���Y��
9���l��7�������U�8�羲��ӥj����b�aWF�bu���4V#��i�a���BK8,QǱI]�&�����w�i�����`ǈ0�[����{,/c(B,f�}}��or�6iUruv�1�)wߣ�!#|�[KJ���P-������T��;ު$=���"`c>���`��Q*���������U����d�JGTj!��N��'RPxm�TS�@�&Y��v�c�d��l�}�7@�����@9`���rSԆ�24�S6�IpKi���i<��u�;%�(�׶��K^�Zcg�:z�Q���:@��&^hu\�v�Xŋ�l�sc.2�Uz�߳���c�Ur*M���S�#�6��u��`�)v����W�1��"�?�c�u�����SGX���(8ի�EA�S�\��H�Չ�J��\o���.˛��ch�ޯF�W�0ؙ�>{ş�d��__z҅� ����)w��k�z'��H�"�Po�8��'(0���I�8���|�2�ل�������߹�0�T'}��m5��e#穇����tFɣeSӅ���MS���@��Y()yWm�g��J��Ĭ&�auCP�[:�wZ�]�B&�R�)/�~[�����&��X+�'F�m�Kj�k��Wuk��@gDf��Is���Î'�-wl��w+ΡՇ�9*�fÏU��z�?	���=Mbq�
i"}6t-���h����v@b�S/�喙������bm:4�\�Qc��8�To;����޸0���H�/��q����������R�(��:U
�{�w�DLPXד(��4VX���#/4�g۴�t�A/k�����YH���W��܂�П"������0��[9���TA9G�U(M����������b�����m�^"it�%�CpLjeY�D��0��"����wl!�{��a���F���n��֛��aL(8H�X�����OO���L��3] ��A��ؗ�1� ���*�!�CZեt(IӴ��%�<հ��s�î�cI�*u졂+p6lqb�YB�n�
��z]A1�Eܒ��+}97�������Xu���6z�a6E5��g�S��B�n�ZV�m��`�~�H���uA�>�H� id��V]���Iާ���֞O32*M�.lt|X��^�����*��<���7/��;�y���+m=�>67�Rb�8Z�
���Xr�/���{�.3������APM��4Rs[,e"rV�i�y��.�!:��
A�Fڠ,��y��q��x?UM���@v4�ZzW�~�͗d��(-�?��^���)B����nW$��J�a��~�uF#�VOr���P����Tp܏���Ӿun��"����N7dc-u+�>Q4%�\f&G}s�4��Hˠ)h�Z��`��-�K; �7�(,�����>��:.�x�mì�qW�g�	��ڥ���m�K9��������L�uyCJei��}����ϳq��t~j��ʵ�8Υ��.Q��DX�P8`v4�%ү �؛](�I�^�dԢ���!�t��&ұ!��[���E��4X#g�D>�Q�"[!�;"�>�_�y�4Lr��08��L~U�D�!�%D�d�0TR^%N;�z�	0P�p]l\����W�Pj9����ؾnD/���/�m$�/�WV㦲��+�nO򈗋�s�3�w7�K.�y�-=zac�7�g�#��q�
[7�~�'�{&Q׆�f��a�x�;�����s�X@��eJ�A�\s�d�Cro��]W������q�ʾ�H�v�Z:Bk����O(�*?cE��#� Ш�&�n�UE�u�5���l���x��Aݟ�*gG�.��\*D��t�|SU@������ޅ	��������/:�����r�T:���}���m�O�ފ��r�ϐ�-��.XT:���]��۾ �Gn��${�S)Ҥ����/VF����!�R5�t�
7#�Ö���fsRA���d� ư:q�Weipfu����@��Z�+��+��9e��~�M�k�m�@v�	?�N�����g�JyWL=8�E!`_��5��9�F��rM|��e���[�}�`[��ǫ��뭥�vI��\���K6߹NRK��
P弯�E���}>���    ې}���?/�d�            x������ � �     