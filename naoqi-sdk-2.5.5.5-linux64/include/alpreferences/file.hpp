/**
 * Copyright (c) Aldebaran Robotics 2015 All Rights Reserved.
 */

#ifndef ALPREFERENCES_FILE_HPP
#define ALPREFERENCES_FILE_HPP

#include <alvalue/alvalue.h>

namespace AL
{
namespace Preferences
{
/**
 * Read all the preferences found in xml files and return them in an ALValue.
 * @param name the name of the preferences file, usually it is a module name.
 * @return an ALValue representing the preferences.
 */
ALValue readPreferencesFile(const std::string& name);

/**
 * Write all the preferences found in the ALValue into an xml file.
 * @param name the name of the preferences file, usually it is a module name.
 * @param pPref preference to write in the file
 * @param ignoreMemoryNames If true all memory names will be removed before saving.
 */
void writePreferenceFile(const std::string& name, const ALValue& preferences);

/**
 * Remove the xml file.
 * @param name the name of the preferences file, usually it is a module name.
 */
void removePreferenceFile(const std::string& name);
} // Preferences
} // AL

#endif // ALPREFERENCES_FILE_HPP
