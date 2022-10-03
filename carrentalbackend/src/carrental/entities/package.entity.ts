import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type PackageDocument = Package & Document;

@Schema({
  timestamps: true,
})
export class Package {
  @Prop({
    required: true,
  })
  source: string;
  @Prop({
    required: true,
  })
  destination: string;
  @Prop({
    required: true,
  })
  vehicleType: string;
  @Prop({
    required: true,
  })
  price: number;
  @Prop({
    required: true,
  })
  deleted: boolean;
}

export const PackageSchema = SchemaFactory.createForClass(Package);
