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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.generator;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.override.AbstractOverrideGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.utils.StrUtils;
import com.a2a.adjava.xmodele.ModelDictionary;
import com.a2a.adjava.xmodele.XDomain;
import com.a2a.adjava.xmodele.XModeleFactory;
import com.a2a.adjava.xmodele.XProject;

/**
 * Checks for screens on the domain and removes the MainActivity if there are any
 */
public class ProcessMainActivityGenerator extends AbstractOverrideGenerator<XDomain<ModelDictionary, XModeleFactory>> {

	/**
	 * logger for the class
	 */
	private static final Logger log = LoggerFactory.getLogger(ProcessMainActivityGenerator.class);

	
	@Override
	public void genere( XProject<XDomain<ModelDictionary, XModeleFactory>> p_oMProject, DomainGeneratorContext p_oContext) throws Exception {
		log.debug("> ProcessMainActivityGenerator.genere");
		Chrono oChrono = new Chrono(true);
		
		if (!p_oMProject.getDomain().getDictionnary().getAllScreens().isEmpty()) {
			File oMainActivity = new File(this.getMainActivityPath(p_oMProject));
			
			if (oMainActivity.exists()) {
				oMainActivity.delete();
			}
		}
		
		log.debug("< ProcessMainActivityGenerator.genere: {}", oChrono.stopAndDisplay());
	}
	
	/**
	 * Returns the complete path to the MainActivity.java file of the project
	 * @param p_oMProject project to use
	 * @return the path to the MainActivity.java file
	 */
	private String getMainActivityPath(XProject<XDomain<ModelDictionary, XModeleFactory>> p_oMProject) {
		String sProjectDir = p_oMProject.getBaseDir();
		
		String sFile = FileTypeUtils.computeFilenameForJavaClass(p_oMProject.getSourceDir(), 
				p_oMProject.getDomain().getRootPackage() + StrUtils.DOT + "MainActivity");
		
		return sProjectDir + "/" + sFile;
	}
}