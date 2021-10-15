{- |
Copyright   : (c) Runtime Verification, 2021
License     : BSD-3-Clause
-}
module Kore.Validate.Pattern (
    Pattern,
) where

import Prelude.Kore
import qualified Kore.Attribute.Pattern.ConstructorLike as Attribute
import Data.Functor.Const (
    Const (..),
 )
import qualified Kore.Attribute.Pattern.Created as Attribute
import qualified Kore.Attribute.Pattern.Defined as Attribute
import qualified Kore.Attribute.Pattern.FreeVariables as Attribute
import qualified Kore.Attribute.Pattern.Function as Attribute
import qualified Kore.Attribute.Pattern.Functional as Attribute
import qualified Kore.Attribute.Pattern.Simplified as Attribute
import Kore.Internal.Variable
import Kore.Sort
import Kore.Syntax.And
import Kore.Syntax.Application
import Kore.Syntax.Bottom
import Kore.Syntax.Ceil
import Kore.Syntax.DomainValue
import Kore.Syntax.Equals
import Kore.Syntax.Exists
import Kore.Syntax.Floor
import Kore.Syntax.Forall
import Kore.Syntax.Iff
import Kore.Syntax.Implies
import Kore.Syntax.In
import Kore.Syntax.Inhabitant
import Kore.Syntax.Mu
import Kore.Syntax.Next
import Kore.Syntax.Not
import Kore.Syntax.Nu
import Kore.Syntax.Or
import Kore.Syntax.Rewrites
import Kore.Syntax.StringLiteral
import Kore.Syntax.Top
import Kore.Internal.Symbol
import Kore.Internal.Alias
import Kore.Internal.Inj
import Kore.Internal.InternalBool
import Kore.Internal.InternalBytes
import Kore.Internal.InternalInt
import Kore.Internal.InternalList
import Kore.Internal.InternalMap
import Kore.Internal.InternalSet
import Kore.Internal.InternalString
import qualified Generics.SOP as SOP
import qualified GHC.Generics as GHC
import Kore.Builtin.Endianness.Endianness (
    Endianness,
 )
import Kore.Builtin.Signedness.Signedness (
    Signedness,
 )
import Kore.Internal.Key (
    Key,
 )

-- | 'PatternF' is the 'Base' functor of validated patterns.
data PatternF child
    = AndF !(And Sort child)
    | ApplySymbolF !(Application Symbol child)
    | -- TODO (thomas.tuegel): Expand aliases during validation?
      ApplyAliasF !(Application (Alias Pattern) child)
    | BottomF !(Bottom Sort child)
    | CeilF !(Ceil Sort child)
    | DomainValueF !(DomainValue Sort child)
    | EqualsF !(Equals Sort child)
    | ExistsF !(Exists Sort VariableName child)
    | FloorF !(Floor Sort child)
    | ForallF !(Forall Sort VariableName child)
    | IffF !(Iff Sort child)
    | ImpliesF !(Implies Sort child)
    | InF !(In Sort child)
    | MuF !(Mu VariableName child)
    | NextF !(Next Sort child)
    | NotF !(Not Sort child)
    | NuF !(Nu VariableName child)
    | OrF !(Or Sort child)
    | RewritesF !(Rewrites Sort child)
    | TopF !(Top Sort child)
    | InhabitantF !(Inhabitant child)
    | StringLiteralF !(Const StringLiteral child)
    | InternalBoolF !(Const InternalBool child)
    | InternalBytesF !(Const InternalBytes child)
    | InternalIntF !(Const InternalInt child)
    | InternalStringF !(Const InternalString child)
    | InternalListF !(InternalList child)
    | InternalMapF !(InternalMap Key child)
    | InternalSetF !(InternalSet Key child)
    | VariableF !(Const (SomeVariable VariableName) child)
    | EndiannessF !(Const Endianness child)
    | SignednessF !(Const Signedness child)
    | InjF !(Inj child)
    deriving stock (Show)
    deriving stock (Foldable, Functor, Traversable)
    deriving stock (GHC.Generic)
    deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)

newtype Pattern = Pattern
    { getPattern ::
        CofreeF
            PatternF
            PatternAttributes
            Pattern
    }
    deriving stock (Show)
    deriving stock (GHC.Generic)
    deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)

-- | @PatternAttributes@ are the attributes of a pattern collected during validation.
data PatternAttributes = PatternAttributes
    { termSort :: !Sort
    , termFreeVariables :: !(Attribute.FreeVariables VariableName)
    , termFunctional :: !Attribute.Functional
    , termFunction :: !Attribute.Function
    , termDefined :: !Attribute.Defined
    , termCreated :: !Attribute.Created
    , termSimplified :: !Attribute.Simplified
    , termConstructorLike :: !Attribute.ConstructorLike
    }
    deriving stock (Eq, Show)
    deriving stock (GHC.Generic)
    deriving anyclass (Hashable, NFData)
    deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)
