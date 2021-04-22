export class AccountReqBody {
  constructor(obj) {
    this.username = obj.username;
    this.email = obj.email;
    this.first_name = obj.first_name;
    this.last_name = obj.last_name;
    this.password = obj.password;
    this.oauth = obj.oauth;
    this.profile_pic = obj.profile_pic;
    this.city = obj.city;
    this.state = obj.state;
    this.zip_code = obj.zip_code;
    this.roles = obj.roles || [];
    this.is_verified = obj.is_verified || false;
  }
}

export class SettingsReqBody {
  constructor(obj) {
    this.uuid = obj.uuid;
    this.show_name = obj.show_name ?? false;
    this.show_email = obj.show_email ?? false;
    this.show_location = obj.show_location ?? false;
    this.organizers_can_see = obj.organizers_can_see ?? true;
    this.volunteers_can_see = obj.volunteers_can_see ?? true;
    this.initiative_map = obj.initiative_map || {};
    this.password_reset_hash = obj.password_reset_hash ?? null;
    this.password_reset_time = obj.password_reset_time ?? null;
    this.verify_account_hash = obj.verify_account_hash ?? null;
    this.cancel_registration_hash = obj.cancel_registration_hash ?? null;
  }
}
