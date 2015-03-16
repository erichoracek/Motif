//
//  AUTBackwardsCompatableNullability.h
//  Pods
//
//  Created by Eric Horacek on 3/15/15.
//
//

// Xcode 6.3 defines new language features to declare nullability
#if __has_feature(nullability)
#define AUT_NS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#define AUT_NS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#define aut_nullable nullable
#define aut_nonnull nonnull
#define aut_null_unspecified null_unspecified
#define aut_null_resettable null_resettable
#define __aut_nullable __nullable
#define __aut_nonnull __nonnull
#define __aut_null_unspecified __null_unspecified
#else
#define AUT_NS_ASSUME_NONNULL_BEGIN
#define AUT_NS_ASSUME_NONNULL_END
#define aut_nullable
#define aut_nonnull
#define aut_null_unspecified
#define aut_null_resettable
#define __aut_nullable
#define __aut_nonnull
#define __aut_null_unspecified
#endif
