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
package com.adeuza.movalysfwk.mf4mdd.commons.umlupdater;

import java.util.Collection;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.messages.MessageHandler;
import com.a2a.adjava.uml.UmlClass;
import com.a2a.adjava.uml.UmlModel;
import com.a2a.adjava.umlupdater.AbstractUmlUpdater;

/**
 * <p>Controle si tous les composants de l'uml commencent part une majuscule.</p>
 *
 * <p>Copyright (c) 2013</p>
 * <p>Company: Adeuza</p>
 *
 *@author ftollec
 */

public class ControlCapitalizationNameClasses extends AbstractUmlUpdater  {


	/** Class Logger */
	private static final Logger log = LoggerFactory.getLogger(ControlCapitalizationNameClasses.class);
	
	@Override
	public void execute(UmlModel p_oUmlModele, Map<String, ?> p_oGlobalSession)
			throws Exception 
	{
		log.debug("> Execute control of classes Capitalization.");
		
		Collection<UmlClass> oAllClasses = p_oUmlModele.getDictionnary().getAllClasses();
		for (UmlClass oClass : oAllClasses)
		{
			String nameClass = oClass.getName();
			if(Character.isLowerCase(nameClass.charAt(0)))
			{
				MessageHandler.getInstance().addWarning("A class like {} should always start with a capital letter", nameClass);
				oClass.setName( StringUtils.capitalize(nameClass));
			}
		}
		log.debug("> End of the control.");
	}

}
