from uuid import uuid4
from random import choice, randint
from datetime import datetime, timedelta
import random
import names
from lorem_text import lorem


all_uuid4 = set()


def gen_uuid4():
    u = uuid4()
    while u in all_uuid4:
        u = uuid4()
    all_uuid4.add(u)
    return u


# Function to generate random phone numbers
def generate_phone_number():
    return f'+66' + ''.join([str(randint(0, 9)) for _ in range(9)])


# Function to generate random timestamps
def generate_timestamp(start_year=2020, end_year=2023):
    year = randint(start_year, end_year)
    month = randint(1, 12)
    day = randint(1, 28)  # To avoid issues with February
    hour = randint(0, 23)
    minute = randint(0, 59)
    second = randint(0, 59)
    return datetime(year, month, day, hour, minute, second)


# Function to generate random scores
def generate_score():
    return random.uniform(0, 5)


# Function to generate random names
def generate_name(_=None):
    return names.get_first_name()


# Function to generate random email
def generate_email(first, last):
    return f'{first}.{last}@vt.in.th'


# Function to generate random text
def generate_text(max_len=100):
    return lorem.sentence()[:max_len]


# Function to generate random URLs
def generate_url():
    return f'https://vt.in.th/{gen_uuid4()}.jpg'


# Function to generate a random boolean
def generate_boolean():
    return random.choice([True, False])


# Generate data for the tables
num_entries = 200

# company table data
companies = [{'company_id': str(gen_uuid4()), 'company_name': generate_name(35), 'company_address': generate_name(300),
              'company_phone': generate_phone_number()} for _ in range(num_entries)]

# admin table data
admins = [{'admin_id': str(gen_uuid4()), 'admin_fname': generate_name(35), 'admin_lname': generate_name(35),
           'admin_phone': generate_phone_number()} for _ in range(num_entries)]

# user table data
users = []
for _ in range(num_entries):
    fname, lname = generate_name(), generate_name()
    d = {
        'email': generate_email(fname, lname),
        'fname': fname,
        'lname': lname,
        'profile_image': f'https://vt.in.th/{gen_uuid4()}.jpg',
        'expired_date_kyc': generate_timestamp()
    }
    users.append(d)

# issue table data
issues_choice = ['issue_a', 'issue_b', 'issue_c']
issues = []
for _ in range(num_entries):
    d = {
        'issue_id': str(gen_uuid4()),
        'issue_type': choice(issues_choice),
        'is_resolved': choice([True, False]),
        'issue_time_stamp': generate_timestamp(),
        'issue_message': generate_text(99),
        'issue_image': f'https://vt.in.th/{gen_uuid4()}.jpg',
        'user_email': choice(users)['email']
    }
    issues.append(d)

# owner table data (assuming all users can be owners)
owners = [{'owner_email': user['email']} for user in users[:len(users) // 2]]

# dweller table data (assuming all users can be dwellers)
dwellers = [{'dweller_email': user['email']} for user in users[len(users) // 2:]]

# Prepare SQL insert statements
insert_statements = []

# Generate insert statements for each table
for company in companies:
    insert_statements.append(
        f"INSERT INTO company VALUES ('{company['company_id']}', '{company['company_name']}', '{company['company_address']}', '{company['company_phone']}');")

for admin in admins:
    insert_statements.append(
        f"INSERT INTO admin VALUES ('{admin['admin_id']}', '{admin['admin_fname']}', '{admin['admin_lname']}', '{admin['admin_phone']}');")

for user in users:
    insert_statements.append(
        f"INSERT INTO \"user\" VALUES ('{user['email']}', '{user['fname']}', '{user['lname']}', '{user['profile_image']}', '{user['expired_date_kyc']}');")

for issue in issues:
    insert_statements.append(
        f"INSERT INTO issue VALUES ('{issue['issue_id']}', '{issue['issue_type']}', {issue['is_resolved']}, '{issue['issue_time_stamp']}', '{issue['issue_message']}', '{issue['issue_image']}', '{issue['user_email']}');")

for owner in owners:
    insert_statements.append(f"INSERT INTO owner VALUES ('{owner['owner_email']}');")

for dweller in dwellers:
    insert_statements.append(f"INSERT INTO dweller VALUES ('{dweller['dweller_email']}');")

# advertisement table data
advertisements = [{'ad_id': str(gen_uuid4()),
                   'start_date': generate_timestamp(),
                   'end_date': generate_timestamp(),
                   'company_id': random.choice(companies)['company_id'],
                   'admin_id': random.choice(admins)['admin_id']} for _ in range(num_entries)]

# issue_review table data
issue_reviews = [{'admin_id': random.choice(admins)['admin_id'],
                  'issue_id': random.choice(issues)['issue_id'],
                  'date_resolved': generate_timestamp()} for _ in range(num_entries)]

# property_review table data
property_reviews = [{'property_id': str(gen_uuid4()),
                     'dweller_email': random.choice(dwellers)['dweller_email'],
                     'review_time_stamp': generate_timestamp(),
                     'image': generate_url(),
                     'score': generate_score(),
                     'description': generate_text(20)} for _ in range(num_entries)]

# like table data
likes = [{'property_id': random.choice(property_reviews)['property_id'],
          'dweller_email': random.choice(dwellers)['dweller_email']} for _ in range(num_entries)]

# property_listing table data
property_listings = [{'property_id': str(gen_uuid4()),
                      'owner_email': random.choice(owners)['owner_email'],
                      'owner_contact': generate_phone_number(),
                      'description': generate_text(20),
                      'residential_type': generate_text(20),
                      'project_name': generate_name(20),
                      'address': generate_text(20),
                      'alley': generate_name(),
                      'street': generate_name(),
                      'sub_district': generate_name(),
                      'district': generate_name(),
                      'province': generate_name(),
                      'country': generate_name(),
                      'postal_code': ''.join([str(random.randint(0, 9)) for _ in range(5)]),
                      'property_list_time_stamp': generate_timestamp()} for _ in range(num_entries)]

# appointment table data
appointments = [{'appointment_id': str(gen_uuid4()),
                 'property_id': random.choice(property_listings)['property_id'],
                 'dweller_email': random.choice(dwellers)['dweller_email'],
                 'appointment_time_stamp': generate_timestamp(),
                 'appointment_date': generate_timestamp(),
                 'is_confirmed': generate_boolean(),
                 'is_rejected': generate_boolean(),
                 'is_met': generate_boolean()} for _ in range(num_entries)]

# image table data
images = [{'property_id': random.choice(property_listings)['property_id'],
           'image': generate_url()} for _ in range(num_entries)]

# property_listing_for_sell table data
property_listing_for_sells = [{'property_id': random.choice(property_listings)['property_id'],
                               'price': random.uniform(50000, 500000),
                               'is_sold': generate_boolean()} for _ in range(num_entries)]

# property_listing_for_rent table data
property_listing_for_rents = [{'property_id': random.choice(property_listings)['property_id'],
                               'price_per_month': random.uniform(1000, 10000),
                               'is_occupied': generate_boolean()} for _ in range(num_entries)]

# transaction table data
transactions = [{'transaction_id': str(gen_uuid4()),
                 'timestamp': generate_timestamp(),
                 'payment_method': generate_name(),
                 'is_released': generate_boolean(),
                 'is_canceled': generate_boolean(),
                 'amount': random.uniform(1000, 100000)} for _ in range(num_entries)]

# rent table data
rents = [{'property_id': random.choice(property_listing_for_rents)['property_id'],
          'dweller_email': random.choice(dwellers)['dweller_email'],
          'transaction_id': random.choice(transactions)['transaction_id'],
          'rent_start_date': generate_timestamp()} for _ in range(num_entries)]

# sell table data
sells = [{'property_id': random.choice(property_listing_for_sells)['property_id'],
          'dweller_email': random.choice(dwellers)['dweller_email'],
          'transaction_id': random.choice(transactions)['transaction_id']} for _ in range(num_entries)]

insert_statements.extend([
    f"INSERT INTO advertisement (ad_id, start_date, end_date, company_id, admin_id) VALUES ('{ad['ad_id']}', '{ad['start_date']}', '{ad['end_date']}', '{ad['company_id']}', '{ad['admin_id']}');"
    for ad in advertisements
])

insert_statements.extend([
    f"INSERT INTO issue_review (admin_id, issue_id, date_resolved) VALUES ('{review['admin_id']}', '{review['issue_id']}', '{review['date_resolved']}');"
    for review in issue_reviews
])

insert_statements.extend([
    f"INSERT INTO property_review (property_id, dweller_email, review_time_stamp, image, score, description) VALUES ('{review['property_id']}', '{review['dweller_email']}', '{review['review_time_stamp']}', '{review['image']}', {review['score']}, '{review['description']}');"
    for review in property_reviews
])

insert_statements.extend([
    f"INSERT INTO \"like\" (property_id, dweller_email) VALUES ('{like['property_id']}', '{like['dweller_email']}');"
    for like in likes
])

insert_statements.extend([
    f"INSERT INTO property_listing (property_id, owner_email, owner_contact, description, residential_type, project_name, address, alley, street, sub_district, district, province, country, postal_code, property_list_time_stamp) VALUES ('{listing['property_id']}', '{listing['owner_email']}', '{listing['owner_contact']}', '{listing['description']}', '{listing['residential_type']}', '{listing['project_name']}', '{listing['address']}', '{listing['alley']}', '{listing['street']}', '{listing['sub_district']}', '{listing['district']}', '{listing['province']}', '{listing['country']}', '{listing['postal_code']}', '{listing['property_list_time_stamp']}');"
    for listing in property_listings
])

insert_statements.extend([
    f"INSERT INTO appointment (appointment_id, property_id, dweller_email, appointment_time_stamp, appointment_date, is_confirmed, is_rejected, is_met) VALUES ('{appointment['appointment_id']}', '{appointment['property_id']}', '{appointment['dweller_email']}', '{appointment['appointment_time_stamp']}', '{appointment['appointment_date']}', {appointment['is_confirmed']}, {appointment['is_rejected']}, {appointment['is_met']});"
    for appointment in appointments
])

insert_statements.extend([
    f"INSERT INTO image (property_id, image) VALUES ('{image['property_id']}', '{image['image']}');"
    for image in images
])

insert_statements.extend([
    f"INSERT INTO property_listing_for_sell (property_id, price, is_sold) VALUES ('{sell['property_id']}', {sell['price']}, {sell['is_sold']});"
    for sell in property_listing_for_sells
])

insert_statements.extend([
    f"INSERT INTO property_listing_for_rent (property_id, price_per_month, is_occupied) VALUES ('{rent['property_id']}', {rent['price_per_month']}, {rent['is_occupied']});"
    for rent in property_listing_for_rents
])

insert_statements.extend([
    f"INSERT INTO transaction (transaction_id, timestamp, payment_method, is_released, is_canceled, amount) VALUES ('{transaction['transaction_id']}', '{transaction['timestamp']}', '{transaction['payment_method']}', {transaction['is_released']}, {transaction['is_canceled']}, {transaction['amount']});"
    for transaction in transactions
])

insert_statements.extend([
    f"INSERT INTO rent (property_id, dweller_email, transaction_id, rent_start_date) VALUES ('{rent['property_id']}', '{rent['dweller_email']}', '{rent['transaction_id']}', '{rent['rent_start_date']}');"
    for rent in rents
])

insert_statements.extend([
    f"INSERT INTO sell (property_id, dweller_email, transaction_id) VALUES ('{sell['property_id']}', '{sell['dweller_email']}', '{sell['transaction_id']}');"
    for sell in sells
])

insert_statements = [f'{e[:-1]} ON CONFLICT DO NOTHING;' for e in insert_statements]

# Print out the insert statements for each table
f_gen = open('gen_data.sql', mode='w')
for s in insert_statements:
    print(s)
    print(s, file=f_gen)
    f_gen.flush()
f_gen.close()
