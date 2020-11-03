hf_events = {
    'event_uuid': None,
    'event_external_id': 'id',
    'name': 'event_id',
    'signup_url': 'signup_link',
    'hero_image_url': {'event_graphics': lambda x: x[0]['url'] if x else None},
    'details_url': None,
    'start_datetime': 'start',
    'end_datetime': 'end',
    'description': 'description',
    'point_of_contact': None,
}

hf_volunteer_openings = {
    'role_uuid': None,
    'role_external_id': 'id',
    'name': 'position_id',
    'details_url': None,
    'hero_image_url': {'team_photo': lambda x: x[0]['url'] if x else None},
    'priority': {'priority_level': lambda x: x.lower().replace(' ','_')},
    'signup_url': 'application_signup_form',
    'point_of_contact': None,
    'num_openings': 'num_openings',
    'min_time_commitment': 'minimum_time_commitment_per_week_hours',
    'max_time_commitment': 'maximum_time_commitment_per_week_hours',
    'overview': 'job_overview',
    'benefits': 'what_youll_learn',
    'responsibilites': 'responsibilities_and_duties',
    'qualifications': 'qualifications'
}

hf_initiatives = {
    'initiative_uuid': None,
    'initiative_external_id': 'id',
    'name': 'initiative_name',
    'details_url': 'details_link',
    'title': 'initiative_name',
    'hero_image_url': {'image': lambda x: x[0]['url'] if x else None},
    'content': 'description',
    'roles': 'volunteer_roles',
    'events': 'events',
    'highlightedItems': None
}
