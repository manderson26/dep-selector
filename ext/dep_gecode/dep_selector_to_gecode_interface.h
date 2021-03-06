//
// Author:: Christopher Walters (<cw@opscode.com>)
// Author:: Mark Anderson (<mark@opscode.com>)
// Copyright:: Copyright (c) 2010-2011 Opscode, Inc.
// License:: Apache License, Version 2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef dep_selector_to_gecode_interface_h
#define dep_selector_to_gecode_interface_h

// Conceptual Api
#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

#ifdef __cplusplus
  class VersionProblem;
#else
  typedef struct VersionProblem VersionProblem;
#endif // __cplusplus

  VersionProblem * VersionProblemCreate(int packageCount, bool dumpStats,
                                        bool debug, const char * logId);
  void VersionProblemDestroy(VersionProblem * vp);


  int VersionProblemSize(VersionProblem *p);
  int VersionProblemPackageCount(VersionProblem *p);

  // Return ID #
  int AddPackage(VersionProblem *problem, int min, int max, int currentVersion);
  // Add constraint for package pkg @ version, 
  // that dependentPackage is at version [minDependentVersion,maxDependentVersion]
  // Returns false if system becomes insoluble.
  void AddVersionConstraint(VersionProblem *problem, int packageId, int version,
			    int dependentPackageId, int minDependentVersion, int maxDependentVersion);

  void MarkPackageSuspicious(VersionProblem *problem, int packageId);
  void MarkPackageRequired(VersionProblem *problem, int packageId);
  void MarkPackagePreferredToBeAtLatest(VersionProblem *problem, int packageId, int weight);

  int GetPackageVersion(VersionProblem *problem, int packageId);
  bool GetPackageDisabledState(VersionProblem *problem, int packageId);

  int GetPackageMax(VersionProblem *problem, int packageId);
  int GetPackageMin(VersionProblem *problem, int packageId);

  int GetDisabledVariableCount(VersionProblem *problem);

  void VersionProblemDump(VersionProblem * problem);
  void VersionProblemPrintPackageVar(VersionProblem * problem, int packageId);

  VersionProblem * Solve(VersionProblem * problem);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // dep_selector_to_gecode_interface_h
