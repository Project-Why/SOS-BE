import { Message } from '@entities/message.entity'

import { EntityRepository, Repository } from 'typeorm'

@EntityRepository(Message)
export class UserRepository extends Repository<Message> {}
