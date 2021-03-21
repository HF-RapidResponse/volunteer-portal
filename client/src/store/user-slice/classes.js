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
  }
}
