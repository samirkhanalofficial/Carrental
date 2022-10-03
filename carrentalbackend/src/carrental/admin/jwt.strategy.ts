import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Admin, AdminDocument } from '../entities/admin.entity';
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    @InjectModel(Admin.name) private adminModel: Model<AdminDocument>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: true,
      secretOrKey: 'process.env.ACCESS_TOKEN_SECRET',
    });
  }

  async validate(payload: any) {
    const user = await this.adminModel.findById(payload.id);
    console.log(user);
    if (user) {
      return payload;
    } else {
      throw new UnauthorizedException();
    }
  }
}
