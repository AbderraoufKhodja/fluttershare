import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String kJobDescription = "kJobDescription";
const String kEmpty = "kEmpty";
const String kJobLocation = "kJobLocation";
const String kLocationField = "kLocationField";
const String kTimeLine = "kTimeLine";
const String kSearch = "kSearch";
const String kChats = "kChats";
const String kForYou = "kForYou";
const String kTopFreelancer = "kTopFreelancer";
const String kNew = "kNew";
const String kTeamChoice = "kTeamChoice";
const String kMissingData = "kMissingData";
const String kTopRated = "kTopRated";
const String kMostExperienced = "kMostExperienced";
const String kHighestCompletionRate = "kHighestCompletionRate";
const String kPopularAdvisors = "kPopularAdvisors";
const String kTopFreelancersAroundMe = "kTopFreelancersAroundMe";
const String kTopTeamChoiceFreelancers = "kTopTeamChoiceFreelancers";
const String kFastCompletions = "kFastCompletions";
const String kHighQualityFreelancers = "kHighQualityFreelancers";
const String kRecommendedForYouSection = "kRecommendedForYouSection";
const String kSuggestedForYouSection = "kSuggestedForYouSection";
const String kRecentlyReviewdSection = "kRecentlyReviewdSection";
const String kNewTalentsSection = "kNewTalentsSection";
const String kTopFreelancerSection = "kTopFreelancerSection";
const String kTeamChoiceFreelancers = "kTeamChoiceFreelancers";
const String kBeTheFirstToHire = "kBeTheFirstToHire";
const String kFreelancersCategories = "kFreelancersCategories";
const String kFreelancers = "kFreelancers";
const String kAroundMe = "kAroundMe";
const String kRecommendedForYou = "kRecommendForYou";
const String kBestFreelancers = "kBestFreelancers";
const String kJobOffers = "kJobOffers";
const String kEvents = "kEvents";
const String kNewTalents = "kNewTalents";
const String kStories = "kStories";
const String kCategory = "kCategory";
const String kJobScreenTitle = "kJobScreenTitle";
const String kEditJob = "kEditJob";
const String kJobPrice = "kJobPrice";
const String kCurrency = "kCurrency";
const String kUnavailable = "kUnavailable";
const String kJobCompleted = "kJobCompleted";
const String kFAQ = "kFAQ";
const String kDisposeFreelancerFirst = "kDisposeFreelancerFirst";
const String kHireNotification = "kHireNotification";
const String kNewMessage = "kNewMessage";
const String kSubmitRequest = "kSubmitRequest";
const String kViewUpdateRequest = "kViewUpdateRequest";
const String kMessagesScreenTitle = "kMessagesScreenTitle";
const String kApply = "kApply";
const String kCancel = "kCancel";
const String kNewJobDescription = "kNewJobDescription";
const String kHasUnresolvedUpdateRequest = "kHasUnresolvedUpdateRequest";
const String kNewLocation = "kNewLocation";
const String kNewDateRange = "kNewDateRange";
const String kNewPrice = "kNewPrice";
const String kLocationErrorText = "kLocationErrorText";
const String kNotJobOwner = "kNotJobOwner";
const String kJobTitle = "kJobTitle";
const String kSettings = "kSettings";
const String kPriceHintText = "kPriceHintText";
const String kDateRangeText = "kDateRangeText";
const String kRequestUpdateJobTerms = "kRequestUpdateJobTerms";
const String kContactTeam = "kContactTeam";
const String kDisposeCurrentFreelancerAndRepostJob =
    "kDisposeCurrentFreelancerAndRepostJob";
const String kProfessionalTitleHint = "kProfessionalTitleHint";
const String kLessThan24Hours = "kLessThan24Hours";
const String kJobDescriptionHint = "kJobDescriptionHint";
const String kJobUpdatedRequested = "kJobUpdatedRequested";
const String kUpdateLocationHint = "kUpdateLocationHint";
const String kManageJob = "kManageJob";
const String kJobsScreenTitle = "kJobsScreenTitle";
const String kCreateFreelanceAccount = "kCreateFreelanceAccount";
const String kCreateClientAccount = "kCreateClientAccount";
const String kSubmit = "kSubmit";
const String kProfessionalInfo = "kProfessionalInfo";
const String kDateRange = "kDateRange";
const String kUpdateRequestFrom = "kUpdateRequestFrom";
const String kJobScheduleHint = "kJobScheduleHint";
const String kUpdateRequested = "kUpdateRequested";
const String kAcceptUpdateJobTerms = "kAcceptUpdateJobTerms";
const String kRejectUpdateJobTerms = "kRejectUpdateJobTerms";
const String kDeleteJob = "kDeleteJob";
const String kFreelancerDismissed = "kFreelancerDismissed";
const String kJobDeleted = "kJobDeleted";
const String kHasFreelancerUpdateRequest = "kHasFreelancerUpdateRequest";
const String kHasOwnerUpdateRequest = "kHasOwnerUpdateRequest";
const String kJobOnGoing = "kJobOnGoing";
const String kUnknownStatu = "kUnknownState";
const String kJobRetrieved = "kJobRetrieved";
const String kJobCanceled = "kJobCanceled";
const String kOwnerCompleted = "kOwnerCompleted";
const String kFreelancerCompleted = "kFreelancerCompleted";
const String kUpdateConfirmCancel = "kUpdateConfirmCancel";
const String kOwnerRating = "kJobOwnerRating";
const String kMySubscriptions = "kMySubscriptions";
const String kHotTopics = "kHotTopics";
const String kTopForums = "kTopForums";
const String kPopularPosts = "kPopularPosts";
const String kUpdateJobTerms = "kUpdateJobTerms";
const String kDismiss = "kDismiss";
const String kDismissReason = "kDismissReason";
const String kMessageForTheTeam = "kMessageForTheTeam";
const String kReasonOfDeleteJob = "kReasonOfDeleteJob";
const String kDelete = "kDelete";
const String kFreelancerNotHired = "kFreelancerNotHired";
const String kHasNoJobFreelancer = "kHasNoJobFreelancer";
const String kShowChat = "kShowChat";
const String kCancelAcceptance = "kCancelAcceptance";
const String kUnapply = "kUnapply";
const String kReject = "kReject";
const String kAccept = "kAccept";
const String kPriceHint = "kPriceHint";
const String kPriceInstruction = "kPriceInstruction";
const String kCreateCard = "kCreateCard";
const String kHasNoFreelanceAccount = "kHasNoFreelanceAccount";
const String kDismissCurrentFreelancerAndPostJobAgain =
    "kDismissCurrentFreelancerAndPostJobAgain";
const String kConnectivityProblem = "kConnectivityProblem";
const String kWelcome = "kWelcome";
const String kDateRangeHint = "kDateRangeHint";
const String kDateRangeInstruction = "kDateRangeInstruction";
const String kJobTitleHint = "kJobTitleHint";
const String kJobTitleInstruction = "kJobTitleInstruction";
const SnackBar kProblemSnackbar = SnackBar(content: Text(kConnectivityProblem));
const String kUsername = "kUsername";
const String kIntro = "kIntro";
const String kPersonalBio = "kPersonalBio";
const String kTooLong = "kTooLong";
const String kTooShort = "kTooShort";
const String kJobsCount = "kJobsCount";
const String kJobComplete = "kJobComplete";
const String kFreelancerQuitJob = "kFreelancerQuitJob";
const String kEvaluation = "KEvaluation";
const String kOk = "kOk";
const String kHasNoJobFreelancerDialogInstruction =
    "kHasNoJobFreelancerDialogInstruction";
const String kEditProfile = "kEditProfile";
const String kLessThan24HoursInstruction = "kLessThan24HoursInstruction";
const String kHasUnresolvedUpdateRequestInstruction =
    "kHasUnresolvedUpdateRequestInstruction";
const String kHire = "kHire";
const String kErrorHasOccurred = "kErrorHasOccurred";
const String kDismissFreelancerBeforeCancel = "kDismissFreelancerBeforeCancel";
const String kDismissFreelancerBeforeCancelInstruction =
    "kDismissFreelancerBeforeCancelInstruction";
const String kHasNoReview = "kHasNoReview";
const TextStyle kTextStyleProfileInfo = TextStyle(fontSize: 16.0);
const TextStyle kTextStyleProfileInfoHeader =
    TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold);
const String kDisplayName = "kDisplayName";
const String kBlankCategoryUrl =
    "https://firebasestorage.googleapis.com/v0/b/khadamat-2dbbb.appspot.com/o/category.jpg?alt=media&token=ed73d107-a621-4de1-98cd-7e0bad173269";
const String kEmail = "kEmail";
const String kJobs = "kJobs";
const String kProfessionalPhoto = "kProfessionalPhoto";
const String kGender = "kGender";
const String kBirthDate = "kBirthDate";
const String kProfessionalCategory = "kProfessionalCategory";
const String kCompetence = "kCompetence";
const String kCreatedAt = "kCreatedAt";
const String kProfessionalExperience = "kProfessionalExperience";
const String kInternship = "kInternship";
const String kDiploma = "kDiploma";
const String kLicence = "kLicence";
const String kCertification = "kCertification";
const String kExperience = "kExperience";
const String kCompetences = "kCompetences";
const String kAchievement = "kAchievement";
const String kFreelancerWorkQuality = "kFreelancerWorkQuality";
const String kReview = "kReview";
const String kSubmitAndComplete = "kSubmitAndComplete";
const String kManage = "kManage";
const String kMore = "kMore";
const String kFreelancerAttitude = "kFreelancerAttitude";
const String kFreelancerTimeManagement = "kFreelancerTimeManagement";
const String kRecommendation = "kRecommendation";
const String kLanguage = "kLanguage";
const String kUploadImage = "kUploadImage";
const String kTellUsAboutYou = "kTellUsAboutYou";
const String kRating = "kRating";
const String kBirthDateController = "kBirthDateController";
const String kFromCamera = "kFromCamera";
const String kFromGallery = "kFromGallery";
const String kProfessionalDescription = "kProfessionalDescription";
const String kPreferences = "kPreferences";
const String kProfessionalTitle = "kProfessionalTitle";
const String kConfirm = "kConfirm";
const String kLocation = "kLocation";
const String kFromList = "kFromList";
const String kFromGPS = "kFromGPS";
const String kSelectLocation = "kSelectLocation";
const String kGenderController = "kGenderController";
const String kMale = "kMale";
const String kFemale = "kFemale";
const String kCountry = "kCountry";
const String kProfessionalCategoryController =
    "kProfessionalCategoryController";
const String kAddProfessionalCategory = "kAddProfessionalCategory";
const String kAddProfessionalTitle = "kAddProfessionalTitle";
const String kCheckProfessionalTitle = "kCheckProfessionalTitle";
const String kCheckProfessionalCategory = "kCheckProfessionalCategory";
const String kUsernameInstruction = "kUsernameInstruction";
const String kOpenChat = "kOpenChat";
const String kAMomentAGo = "kAMomentAGo";
const String kProfessionalTitleInstruction = "kProfessionalTitleInstruction";
const String kPersonalBioInstruction = "kPersonalBioInstruction";
const String kLocationInstruction = "kLocationInstruction";
const String kBirthDateInstruction = "kBirthDateInstruction";
const String kGenderInstruction = "kGenderInstruction";
const String kProfessionalDescriptionInstruction =
    "kProfessionalDescriptionInstruction";
const String kProfessionalCategoryInstruction =
    "kProfessionalCategoryInstruction";
const String kKeyWordsInstruction = "kKeyWordsInstruction";
const String kDiplomaInstruction = "kDiplomaInstruction";
const String kLicenceInstruction = "kLicenceInstruction";
const String kCertificationInstruction = "kCertificationInstruction";
const String kLanguageInstruction = "kLanguageInstruction";
const String kExperienceInstruction = "kExperienceInstruction";
const String kInternshipInstruction = "kInternshipInstruction";
const String kCompetencesInstruction = "kCompetencesInstruction";
const String kAchievementInstruction = "kAchievementInstruction";
const String kRecommendationInstruction = "kRecommendationInstruction";
const String kTrendingTopRatedSection = "kTrendingTopRatedSection";
const String kTrendingExperiencedSection = "kTrendingExperiencedSection";
const String kTrendingHighestCompletionRateSection =
    "kTrendingHighestCompletionRateSection";
const String kTrendingPopularAdvisorsSection =
    "kTrendingPopularAdvisorsSection";
const String kTrendingHighQualityFreelancersSection =
    "kTrendingHighQualityFreelancersSection";
const String kTrendingTopTeamChoiceFreelancersSection =
    "kTrendingTopTeamChoiceFreelancersSection";
const String kTrendingTopFreelancersAroundMeSection =
    "kTrendingTopFreelancersAroundMeSection";

const String kBlankProfileUrl =
    "https://firebasestorage.googleapis.com/v0/b/khadamat-2dbbb.appspot.com/o/freelancer_105303619841718040097.jpg?alt=media&token=cee059e4-bbf9-48ad-b668-88b5282d2339";

dynamic fieldGetter(
    {@required DocumentSnapshot document, @required String field}) {
  try {
    return document[field];
  } catch (error) {
    print("$error; missing field: $field");
    return null;
  }
}
