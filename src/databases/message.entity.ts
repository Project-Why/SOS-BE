import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
} from 'typeorm'

@Entity()
export class Message {
  @PrimaryGeneratedColumn()
  id!: number

  @Column({ type: 'varchar', length: 1024 })
  code: string

  @CreateDateColumn({ type: 'timestamp' })
  createdAt!: string

  @Column({ type: 'varchar' })
  location: string
}
