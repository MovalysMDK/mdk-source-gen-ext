/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.ios.generators;

import java.io.File;
import java.util.Locale;

import org.apache.commons.lang3.StringUtils;

import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.commons.generator.AbstractInjectLabelGenerator;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDictionnary;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IDomain;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IModelFactory;

/**
 * Label generator for MF4I
 * @author lmichenaud
 *
 */
public class MF4ILabelGenerator extends AbstractInjectLabelGenerator<MF4IDomain<MF4IDictionnary,MF4IModelFactory>> {

	/**
	 * Generated file
	 */
	private static final String GENERATED_FILE = "Localizable-project.strings";	
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected File getOutputFile(XProject<MF4IDomain<MF4IDictionnary,MF4IModelFactory>> p_oProject, Locale p_oLocale) {
		return new File(
			StringUtils.join("resources/strings/", p_oLocale.getLanguage(), ".lproj"), GENERATED_FILE);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	protected Locale[] getLocales() {
		return new Locale[] { Locale.FRENCH, Locale.ENGLISH };
	}
}
