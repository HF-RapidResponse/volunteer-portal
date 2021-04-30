import re


def sanitize_email(input_email: str) -> str:
    val_array = input_email.strip().lower().split('@')
    sani_user = re.sub(
        r'\.', '', val_array[0]) if val_array[1] == 'gmail.com' else val_array[0]
    return f'{sani_user}@{val_array[1]}'


def trim_str(input: str) -> str:
    return input.strip() if input else input


def sanitize_data(payload):
    for key in payload:
        if key == 'email':
            payload[key] = sanitize_email(payload[key])
        elif key == 'password':
            continue
        else:
            payload[key] = trim_str(payload[key])


def row2dict(row):
    return dict((col, getattr(row, col)) for col in row.__table__.columns.keys())
