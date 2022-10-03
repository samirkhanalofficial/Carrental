import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { IsEmail } from 'class-validator';
import { Document } from 'mongoose';

export type AdminDocument = Admin & Document;

@Schema({
  timestamps: true,
})
export class Admin {
  @Prop({
    required: true,
    minlength: 3,
  })
  name: string;

  @Prop({
    required: true,
  })
  @IsEmail()
  email: string;

  @Prop({
    required: true,
  })
  password: string;
}

export const AdminSchema = SchemaFactory.createForClass(Admin);
