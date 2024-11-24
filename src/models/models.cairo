use starknet::ContractAddress;

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Moves {
    #[key]
    pub player: ContractAddress,
    pub remaining: u8,
    pub last_direction: Direction,
    pub can_move: bool,
}



#[derive(Drop, Serde)]
#[dojo::model]
pub struct DirectionsAvailable {
    #[key]
    pub player: ContractAddress,
    pub directions: Array<Direction>,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Position {
    #[key]
    pub player: ContractAddress,
    pub vec: Vec2,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Pet {
    #[key]
    pub pet_id: u32,
    pub pet_name: felt252,
    pub pet_type: felt252,
    pub owner_id: felt252,
}

#[derive(Serde, Copy, Drop, Introspect)]
pub enum Direction {
    None,
    Left,
    Right,
    Up,
    Down,
}


#[derive(Copy, Drop, Serde, Introspect)]
pub struct Vec2 {
    pub x: u32,
    pub y: u32
}


impl DirectionIntoFelt252 of Into<Direction, felt252> {
    fn into(self: Direction) -> felt252 {
        match self {
            Direction::None => 0,
            Direction::Left => 1,
            Direction::Right => 2,
            Direction::Up => 3,
            Direction::Down => 4,
        }
    }
}


#[generate_trait]
impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        if self.x - self.y == 0 {
            return true;
        }
        false
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
}

#[generate_trait]
impl PetImpl of PetTrait {
    fn create_pet(pet_id: u32, pet_name: felt252, pet_type: felt252, owner_id: felt252) -> Pet {
        Pet {
            pet_id: pet_id,
            pet_name: pet_name,
            pet_type: pet_type,
            owner_id: owner_id,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{Pet, PetTrait, Position, Vec2, Vec2Trait};

    #[test]
    fn test_vec_is_zero() {
        assert(Vec2Trait::is_zero(Vec2 { x: 0, y: 0 }), 'not zero');
    }

    #[test]
    fn test_vec_is_equal() {
        let position = Vec2 { x: 420, y: 0 };
        assert(position.is_equal(Vec2 { x: 420, y: 0 }), 'not equal');
    }

    #[test]
    fn test_create_pet() {
        let player_id = 1; 
        let pet_id = 1;    
        let pet_name = 'Buddy';
        let pet_type = 'Dog';

        let pet = PetTrait::create_pet(pet_id, pet_name, pet_type, player_id);

        assert(pet.pet_id == pet_id, 'Pet ID not correct');
        assert(pet.pet_name == pet_name, 'Pet name not correct');
        assert(pet.pet_type == pet_type, 'Pet type not correct');
        assert(pet.owner_id == player_id, 'Owner ID not correct');
    }
}
